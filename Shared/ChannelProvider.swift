import Foundation
import Promises
import AVFoundation

protocol ChannelProvider {
    var preloadedChannels: [Channel] { get }
    func getChannnels() -> Promise<[Channel]>
    func getEpisodes(in channel: Channel) -> Promise<[ChannelEpisode]>
    func getPlayer(forEpisode: ChannelEpisode) -> Promise<AVPlayer>
}
