//
//  BroadcastViewController.swift
//  BoxCast
//
//  Created by Camden Fullmer on 5/13/17.
//  Copyright © 2017 BoxCast, Inc. All rights reserved.
//

import UIKit
import BoxCast
import AVKit

class BroadcastViewController: UIViewController {

    var broadcast: Broadcast?
    var broadcastView: BroadcastView?
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadBroadcast()
        loadBroadcastView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func playButtonTapped(_ sender: Any) {
        presentPlayerController()
    }
    
    // MARK: - Private
    
    private func loadThumbnail() {
        DispatchQueue.global().async {
            guard let url = self.broadcast?.thumbnailURL else {
                return
            }
            var image: UIImage?
            do {
                let data = try Data(contentsOf: url)
                image = UIImage(data: data)
            } catch {
                print("error loading thumnail: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }
    
    private func loadBroadcast() {
        guard let broadcast = broadcast else {
            return
        }
        
        BoxCastClient.sharedClient?.getBroadcast(broadcastId: broadcast.id, channelId: broadcast.channelId) { broadcast, error in
            if let broadcast = broadcast {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                self.broadcast = broadcast
                self.title = broadcast.name
                self.nameLabel.text = broadcast.name
                self.dateLabel.text = formatter.string(from: broadcast.startDate)
                self.descriptionLabel.text = broadcast.description
                
                self.loadThumbnail()
            } else {
                print("error loading broadcast view: \(error!.localizedDescription)")
            }
        }
    }
    
    private func loadBroadcastView() {
        guard let broadcast = broadcast else {
            return
        }
        
        BoxCastClient.sharedClient?.getBroadcastView(broadcastId: broadcast.id) { view, error in
            if let view = view {
                self.broadcastView = view
                self.playButton.isEnabled = true
            } else {
                print("error loading broadcast view: \(error!.localizedDescription)")
            }
        }
    }
    
    private func presentPlayerController() {
        guard let broadcastView = broadcastView, let broadcast = broadcast else {
            return
        }
        
        let player = BoxCastPlayer(broadcast: broadcast, broadcastView: broadcastView)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player?.play()
        }
    }

}
