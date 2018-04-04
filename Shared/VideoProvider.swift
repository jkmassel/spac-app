//
//  VideoProvider.swift
//  SPAC
//
//  Created by Jeremy Massel on 2018-04-01.
//  Copyright © 2018 The Paperless Classroom Corp. All rights reserved.
//

import Foundation
import Promises

let url2 = URL(string: "https://player.vimeo.com/play/858287697?s=237823569_1522723716_950bc34ed4c43cd1a9c54adcd1f14742")!

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
					let series = try decoder.decode([Series].self, from: data)
					fulfill(series)
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

	let episodes: [Episode]

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

struct Episode : Codable{
	let id: String
	let title: String
	let duration: String
	let date: Date

	let videoURL: String?
	let audioURL: String?

	var url: URL{
		return URL(string: "https://spac-podcasts.backburnerdesign.com/media/video/test.mp4")!
	}

	enum CodingKeys: String, CodingKey
	{
		case id
		case title
		case duration
		case date

		case videoURL = "video-url"
		case audioURL = "audio-url"
	}
}
