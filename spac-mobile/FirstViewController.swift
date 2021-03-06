//
//  FirstViewController.swift
//  spac-mobile
//
//  Created by Jeremy Massel on 2018-04-01.
//  Copyright © 2018 The Paperless Classroom Corp. All rights reserved.
//

import UIKit
import AVKit

class FirstViewController: UIViewController {

	private let url = URL(string: "https://y2e1jje-lh.akamaihd.net/i/WeekendServices_1@619990/index_2000_av-p.m3u8?sd=10&rebase=on")!

	private var player : AVPlayer!
	private var controller: AVPlayerViewController!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		self.player = AVPlayer(url: self.url)

		self.controller = AVPlayerViewController()
		self.controller.player = self.player
		self.controller.allowsPictureInPicturePlayback = true
		self.controller.entersFullScreenWhenPlaybackBegins = true
		self.controller.exitsFullScreenWhenPlaybackEnds = true

		self.addChildViewController(self.controller)
		self.view.addSubview(self.controller.view)
		self.controller.view.frame = self.view.frame
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		self.player.play()
	}
}

