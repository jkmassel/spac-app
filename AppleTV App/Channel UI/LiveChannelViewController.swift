import UIKit
import AVKit
import Promises

class LiveChannelViewController: AVPlayerViewController {

    private let channel: Channel
    private let channelProvider: ChannelProvider

    private var videoViewController: AVPlayerViewController!

    init(withChannel channel: Channel, channelProvider: ChannelProvider = DIContainer.shared.channelProvider){
        self.channel = channel
        self.channelProvider = channelProvider

        super.init(nibName: nil, bundle: nil)

        self.tabBarItem = UITabBarItem(title: channel.title, image: nil, tag: 0)
        self.tabBarItem.isEnabled = channel.enabledByDefault
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        channelProvider
            .getLiveFeeds(in: channel)
            .then { self.tabBarItem.isEnabled = !$0.isEmpty }
            .validate { !$0.isEmpty }
            .then { self.channelProvider.getPlayer(forEpisode: $0.first!) }
            .then(on: .main) { player in
                self.player = player
            }

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMenuPress))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        tabBarController?.view.addGestureRecognizer(tapRecognizer)
    }

    @objc private func handleMenuPress() {
        self.showTabBar()
        self.tabBarController?.tabBar.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Hide the tab bar when playback starts – this is a bit of a weird hack, it should hide itself if full-screen
        // media is playing
        self.hideTabBar()

        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.player?.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.player?.pause()

        // Show the tab bar when playback stops
        self.showTabBar()
    }

    private func showTabBar() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.tabBarController?.tabBar.layer.opacity = 1
        }
    }

    private func hideTabBar() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.tabBarController?.tabBar.layer.opacity = 0
        }
    }
}

extension LiveChannelViewController: TabBarItemStateRefreshable {
    func refreshTabBarItemState() {
        channelProvider
            .getFeedIsLive(for: self.channel)
            .then(on: .main) { isLive in
                self.tabBarItem.isEnabled = isLive
            }
    }
}
