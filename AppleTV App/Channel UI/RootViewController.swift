import Foundation
import UIKit

class RootViewController: UITabBarController {
    private let _viewControllers = DIContainer.shared.preloadedChannels.map(ChannelViewController.init)
    
    override func viewDidLoad() {
        self.viewControllers = _viewControllers
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tabBar.selectedItem?.isEnabled == false {
            self.selectedIndex = 1
        }

        super.viewWillAppear(animated)
    }
}
