import Foundation

struct Channel {
    let id: String
    let title: String
    let enabledByDefault: Bool
    let isLiveChannel: Bool
    
    init(id: String, title: String, isLiveChannel: Bool = false, enabledByDefault: Bool = true) {
        self.id = id
        self.title = title
        self.isLiveChannel = isLiveChannel
        self.enabledByDefault = enabledByDefault
    }
}

struct ChannelEpisode: Equatable, Codable {
    let id: String
    let channelId: String
    let title: String
    let description: String
    let date: Date
    let imageUrl: URL?
}
