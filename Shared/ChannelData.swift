import Foundation

struct Channel {
    let id: String
    let title: String
}

struct ChannelEpisode: Equatable, Codable {
    let id: String
    let channelId: String
    let title: String
    let description: String
    let date: Date
    let imageUrl: URL?
}
