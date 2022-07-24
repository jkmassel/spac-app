import Foundation
import ImageIO

struct EpisodeCache {
    
    private let cache: CacheImplementation
        
    init(type: CacheImplementation = FileCache()) {
        self.cache = type
    }

    func getEpisodes(forChannel channel: Channel) throws -> [ChannelEpisode] {
        try cache.get(cacheKey(forChannel: channel)) ?? []
    }

    func setEpisodes(_ episodes: [ChannelEpisode], forChannel channel: Channel) throws {
        try cache.set(cacheKey(forChannel: channel), to: episodes)
    }

    private func cacheKey(forChannel channel: Channel) -> String {
        "channel-\(channel.id)"
    }
}
