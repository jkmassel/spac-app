import Foundation
import UIKit

class RootViewController: UITabBarController {
    private let _viewControllers = DIContainer.shared.channelProvider.channelViewControllers
    
    override func viewDidLoad() {
        self.viewControllers = _viewControllers
        super.viewDidLoad()

        self.disableTabBarItemsIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.tabBar.selectedItem?.isEnabled == false {
            self.selectedIndex = 1
        }

        super.viewWillAppear(animated)
    }

    func disableTabBarItemsIfNeeded() {
        for viewController in _viewControllers {
            (viewController as? TabBarItemStateRefreshable)?.refreshTabBarItemState()
        }
    }
}
