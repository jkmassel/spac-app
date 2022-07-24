import Foundation
import BoxCast
import Promises
import AVFoundation

struct BoxCastVideoProvider: ChannelProvider {
    
    private let channels: [Channel]

    init(channels: [Channel]) {
        self.channels = channels
        BoxCastClient.setUp()
    }

    var preloadedChannels: [Channel] {
        self.channels
    }
    
    func getChannnels() -> Promise<[Channel]> {
        Promise(self.channels)
    }

    func getEpisodes(in channel: Channel) -> Promise<[ChannelEpisode]> {
        getBroadcasts(forChannel: channel)
            .then(convertBroadcastsToEpisodes)
    }

    func getPlayer(forEpisode episode: ChannelEpisode) -> Promise<AVPlayer> {
        let client = BoxCastClient.sharedClient!
        return Promise { fulfill, reject in

            client.getBroadcast(broadcastId: episode.id, channelId: episode.channelId) { broadcast, error in

                guard error == nil else {
                    reject(error!)
                    return
                }
                
                if let broadcast = broadcast {
                    client.getBroadcastView(broadcastId: broadcast.id) { broadcastView, error in
                        guard error == nil else {
                            reject(error!)
                            return
                        }

                        if let broadcastView = broadcastView {
                            fulfill(BoxCastPlayer(broadcast: broadcast, broadcastView: broadcastView)!)
                        }
                    }
                }
            }
        }
    }

    func getBroadcast(forEpisode episode: ChannelEpisode) -> Promise<Broadcast> {
        wrap {
            BoxCastClient.sharedClient!
                .getBroadcast(
                    broadcastId: episode.id,
                    channelId: episode.channelId,
                    completionHandler: $0
                )
        }
        .then{ $0! }
    }

    func getBroadcastView(forEpisode episode: ChannelEpisode) -> Promise<BroadcastView> {
        wrap {
            BoxCastClient.sharedClient!.getBroadcastView(broadcastId: episode.id, completionHandler: $0)
        }
        .then{ $0! }
    }

    private func getBroadcasts(forChannel channel: Channel, page: Int = 1) -> Promise<BroadcastList> {
        let path = "/channels/\(channel.id)/broadcasts"
        let params = [
            "l" : 100
        ]

        return Promise { fulfill, reject in
            BoxCastClient.sharedClient!.getJSON(for: path, parameters: params) { (json, error) in
                if let json = json {
                    do {
                        let broadcastList = try BroadcastList(channelId: channel.id, json: json)
                        fulfill(broadcastList)
                    } catch {
                        reject(error)
                    }
                } else {
                    reject(error ?? BoxCastError.unknown)
                }
            }
        }
    }

    private func convertBroadcastsToEpisodes(_ list: BroadcastList) -> [ChannelEpisode] {
        list.map { broadcast in
            ChannelEpisode(
                id: broadcast.id,
                channelId: broadcast.channelId,
                title: broadcast.name,
                description: broadcast.description,
                date: broadcast.startDate,
                imageUrl: broadcast.thumbnailURL
            )
        }.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
}

extension Broadcast: Equatable {
    public static func == (lhs: Broadcast, rhs: Broadcast) -> Bool {
        return lhs.id == rhs.id
    }
}
