//
//  SeriesCollectionViewController.swift
//  SPAC
//
//  Created by Jeremy Massel on 2018-04-02.
//  Copyright © 2018 The Paperless Classroom Corp. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import Dwifft

private let reuseIdentifier = "Cell"
private let cellLabelSize = CGSize(width: 470, height: 80)

class SeriesCollectionViewCell: UICollectionViewCell{

	private let imageView = UIImageView(image: nil)
	private let label = UILabel(frame: .zero)

	var series: Series?{
		didSet{

			self.imageView.sd_setImage(with: series?.previewImageURL, placeholderImage: nil)
			self.imageView.adjustsImageWhenAncestorFocused = true

			self.label.text = series?.title
			self.label.textAlignment = .center
			self.label.font = UIFont.preferredFont(forTextStyle: .body)
			self.label.numberOfLines = 2

			self.label.sizeToFit()
		}
	}

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		self.contentView.addSubview(self.imageView)
		self.imageView.frame = CGRect(origin: .zero, size: CGSize(width: 470, height: 210))

		self.contentView.addSubview(self.label)
		self.label.frame = CGRect(origin: CGPoint(x: 0, y: 220), size: cellLabelSize)
	}

	override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

		if self.isFocused{
			coordinator.addCoordinatedAnimations({
				self.label.frame = CGRect(origin: CGPoint(x: 0, y: 240), size: cellLabelSize)
			}, completion: nil)
		}
		else{
			coordinator.addCoordinatedAnimations({
				self.label.frame = CGRect(origin: CGPoint(x: 0, y: 220), size: cellLabelSize)
			}, completion: nil)
		}
	}
}

class SeriesCollectionViewController: UICollectionViewController {

	private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

	init() {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 470, height: 270)

		//as recommended by https://developer.apple.com/tvos/human-interface-guidelines/visual-design/layout/
		layout.sectionInset = UIEdgeInsets(top: 60, left: 90, bottom: 60, right: 90)

		super.init(collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override var collectionViewLayout: UICollectionViewFlowLayout{
		return super.collectionViewLayout as! UICollectionViewFlowLayout
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView, initialSectionedValues: self.series)

		// Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(SeriesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

		self.view.addSubview(self.spinner)
		self.spinner.startAnimating()
		self.spinner.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}

        // Do any additional setup after loading the view.
		self.reloadSeries()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.reloadSeries()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.diffCalculator?.numberOfSections() ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.diffCalculator?.numberOfObjects(inSection: section) ?? 0
	}

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SeriesCollectionViewCell

		if let series = self.diffCalculator?.value(atIndexPath: indexPath){
			cell.series = series
		}

        return cell
    }

	func reloadSeries(){

		VideoProvider.shared.fetchSeries()
			.then { series in
//				debugPrint("Fetched \(series.count) series")
				self.series = SectionedValues([("Series", series.filter{ $0.hasEpisodes })])
			}
			.catch { (error) in
				let ac = UIAlertController(title: "Error Fetching Series", message: error.localizedDescription, preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(ac, animated: true, completion: nil)
			}
			.always {
				self.spinner.removeFromSuperview()
			}
	}

	var series: SectionedValues<String, Series> = SectionedValues([("Series", [])]){
		didSet { self.diffCalculator?.sectionedValues = self.series }
	}

	var diffCalculator: CollectionViewDiffCalculator<String, Series>?

    // MARK: UICollectionViewDelegate
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		guard let series = self.diffCalculator?.value(atIndexPath: indexPath) else { return }
		let seriesViewController = SeriesViewController(withSeries: series)

		//A special case for watching live
		if series.id == liveSeriesID, let url = series.latestEpisode?.url{
			self.present(PlayerViewController(withURL: url), animated: true, completion: nil)
		}
		else{
			self.present(seriesViewController, animated: true, completion: nil)
		}
	}
}
