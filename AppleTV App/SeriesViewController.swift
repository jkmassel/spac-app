//
//  ServiceListTableViewController.swift
//  SPAC
//
//  Created by Jeremy Massel on 2018-04-01.
//  Copyright © 2018 The Paperless Classroom Corp. All rights reserved.
//

import UIKit
import AVKit

let df: DateFormatter = {
	let df = DateFormatter()
	df.dateFormat = "MMM dd, yyyy"

	return df
}()

class SeriesViewController: UIViewController {

	private let series: Series

	private let seriesImageView = UIImageView(image: nil)
	private let seriesDescription = UILabel(frame: .zero)
	private let tableView = UITableView(frame: .zero)

	init(withSeries series: Series){
		self.series = series
		super.init(nibName: nil, bundle: nil)

		self.seriesImageView.sd_setImage(with: series.previewImageURL, placeholderImage: nil)
		self.seriesDescription.text = series.description
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.addSubview(self.seriesImageView)
		self.seriesImageView.snp.makeConstraints { (make) in
			make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			make.width.equalTo(940)
			make.height.equalTo(420)
		}

		self.view.addSubview(self.seriesDescription)
		self.seriesDescription.snp.makeConstraints { (make) in
			make.width.equalTo(940)
			make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
			make.top.equalTo(self.seriesImageView.snp.bottom).offset(32)
			make.bottom.greaterThanOrEqualTo(self.view.safeAreaLayoutGuide.snp.bottom).priority(250)
		}

		self.seriesDescription.numberOfLines = 0
		self.seriesDescription.font = UIFont.preferredFont(forTextStyle: .body)

		self.view.addSubview(self.tableView)
		self.tableView.snp.makeConstraints { (make) in
			make.width.equalTo(675)
			make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)

			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
		}

		//Set up the table view
		self.tableView.dataSource = self
		self.tableView.delegate = self
    }
}

extension SeriesViewController : UITableViewDataSource{

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.series.episodes.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let message = self.series.episodes[indexPath.row]
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

		cell.textLabel?.text = message.title
		cell.detailTextLabel?.text = df.string(from: message.date)

		cell.accessoryType = .disclosureIndicator

		return cell
	}
}

extension SeriesViewController : UITableViewDelegate{

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let messageURL = self.series.episodes[indexPath.row].url
		
		let playerViewController = PlayerViewController(withURL: messageURL)
		self.present(playerViewController, animated: true, completion: nil)
	}
}
