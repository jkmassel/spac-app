import UIKit
import AVKit

class ChannelViewPlayer: AVPlayerViewController {

    private let channelEpisode: ChannelEpisode
    private let channelProvider = DIContainer.shared.channelProvider

    init(withEpisode episode: ChannelEpisode){
        self.channelEpisode = episode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        channelProvider.getPlayer(forEpisode: self.channelEpisode)
            .then { player in
                self.player = player
                self.player?.play()
            }

        // Hide the tab bar when playback starts – this is a bit of a weird hack, it should hide itself if full-screen
        // media is playing
        self.tabBarController?.tabBar.isHidden = true

        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player?.pause()

        // Show the tab bar when playback stops
        self.tabBarController?.tabBar.isHidden = false
    }
}
