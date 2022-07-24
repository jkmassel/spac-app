import Foundation

struct Channel {
    let id: String
    let title: String
    let disabledByDefault: Bool
    
    init(id: String, title: String, disabledByDefault: Bool = false) {
        self.id = id
        self.title = title
        self.disabledByDefault = disabledByDefault
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
