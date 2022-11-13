import Foundation
import Promises
import AVFoundation
import UIKit

protocol ChannelProvider {
    var preloadedChannels: [Channel] { get }
    var channelViewControllers: [UIViewController] { get }
    func getChannnels() ->  Promise<[Channel]>
    func getEpisodes(in channel: Channel) -> Promise<[ChannelEpisode]>
    func getLiveFeeds(in channel: Channel) -> Promise<[ChannelEpisode]>
    func getFeedIsLive(for channel: Channel) -> Promise<Bool>
    func getPlayer(forEpisode: ChannelEpisode) -> Promise<AVPlayer>
}
