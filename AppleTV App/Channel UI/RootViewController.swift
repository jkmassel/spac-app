import Foundation
import UIKit

class RootViewController: UITabBarController {
    private let _viewControllers = DIContainer.shared.preloadedChannels.map(ChannelViewController.init)
    
    override func viewDidLoad() {
        self.viewControllers = _viewControllers
        super.viewDidLoad()
    }
}
