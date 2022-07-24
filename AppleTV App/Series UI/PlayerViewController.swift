import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController {

	private let url: URL

	init(withURL url: URL){
		self.url = url
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.delegate = self
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		//Schedule the player setup on the next view layout cycle
		DispatchQueue.main.async {
			self.player = AVPlayer(url: self.url)
			self.player?.play()
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.player?.pause()
	}
}

extension PlayerViewController : AVPlayerViewControllerDelegate{

}
