import Foundation

struct DIContainer {
    static var shared: DIContainer!

    let channelProvider: ChannelProvider
    var preloadedChannels: [Channel] {
        channelProvider.preloadedChannels
    }
}
