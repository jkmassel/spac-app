//
//  VideoProvider.swift
//  SPAC
//
//  Created by Jeremy Massel on 2018-04-01.
//  Copyright © 2018 The Paperless Classroom Corp. All rights reserved.
//

import Foundation
import Promises

let liveSeriesID = UUID().uuidString
let watchOnlineURL = URL(string: "https://y2e1jje-lh.akamaihd.net/i/WeekendServices_1@619990/master.m3u8")!

struct VideoProvider{

	static let endpoint = URL(string: "https://spac-podcasts.backburnerdesign.com/wp-json/feeder/v1/fetch")!
	static let shared = VideoProvider()

	func fetchSeries() -> Promise<[Series]>{

		return Promise<[Series]>{ fulfill, reject in

			URLSession.shared.dataTask(with: VideoProvider.endpoint, completionHandler: { (data, response, error) in

				guard error == nil else {
					reject(error!)
					return
				}

				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .iso8601

				guard let data = data else { return }

				do{
					var series = try decoder.decode([Series].self, from: data)

					let episode = Episode(id: liveSeriesID, title: "Watch Online", date: Date(), videoURL: watchOnlineURL.absoluteString)
					let watchOnlineSeries = Series(id: liveSeriesID, title: "Watch Online", description: "", image: "https://spac-podcasts.backburnerdesign.com/media/watch%20online%20graphic.png", episode: episode)
					series.insert(watchOnlineSeries, at: 0)

					fulfill(series.sorted(by: { (one, two) -> Bool in
						return one.latestEpisode?.date ?? Date() > two.latestEpisode?.date ?? Date()
					}))
				}
				catch let err{
					reject(err)
				}

			}).resume()
		}
	}
}

struct Series : Codable{
	let id: String
	let title: String
	let description: String
	let previewImage: String

	private let episodes: [Episode]

	init(id: String, title: String, description: String, image: String, episode: Episode){
		self.id = id
		self.title = title
		self.description = description
		self.previewImage = image

		self.episodes = [episode]
	}

	var previewImageURL: URL?{
		return URL(string: self.previewImage)
	}

	enum CodingKeys: String, CodingKey
	{
		case id
		case title
		case description
		case episodes

		case previewImage = "preview-image"
	}
}

extension Series{

	var hasEpisodes: Bool{
		return !self.filteredEpisodes.isEmpty
	}

	var filteredEpisodes: [Episode]{
		return self.episodes.filter{ $0.url != nil }
	}

	var latestEpisode: Episode?{
		return self.episodes.sorted(by: { (ep1, ep2) -> Bool in
			return ep1.date < ep2.date
		}).last
	}
}

struct Episode : Codable{

	let id: String
	let entryTitle: String
	let duration: String
	let date: Date

	let videoTitle: String?
	let videoURL: String?
	let audioURL: String?

	var url: URL?{
		guard let videoURL = self.videoURL,
			let url = URL(string: videoURL) else { return nil }

		return url
	}

	var title: String{
		return self.videoTitle ?? self.entryTitle
	}

	init(id: String, title: String, date: Date, videoURL: String){
		self.id = id
		self.entryTitle = title
		self.date = date
		self.duration = ""

		self.videoTitle = title
		self.videoURL = videoURL
		self.audioURL = nil
	}

	enum CodingKeys: String, CodingKey
	{
		case id
		case entryTitle = "title"
		case duration
		case date

		case videoTitle = "video-title"
		case videoURL = "video-url"
		case audioURL = "audio-url"
	}
}
