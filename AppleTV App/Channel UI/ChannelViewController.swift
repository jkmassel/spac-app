import Foundation
import UIKit
import Dwifft

class ChannelViewController: UINavigationController {
    private let channel: Channel

    init(channel: Channel) {
        self.channel = channel

        super.init(rootViewController: ChannelCollectionViewController(channel: channel))

        self.tabBarItem = UITabBarItem(title: channel.title, image: nil, tag: 0)
        
        if channel.disabledByDefault {
            self.tabBarItem.isEnabled = false
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChannelCollectionViewController: UICollectionViewController {

    private let channel: Channel
    private let reuseIdentifier = "episode-cell"

    private var diffCalculator: CollectionViewDiffCalculator<String, ChannelEpisode>?
    private var episodes: SectionedValues<String, ChannelEpisode> = SectionedValues([("Episodes", [])]){
        didSet { self.diffCalculator?.sectionedValues = self.episodes }
    }

    private let spinner = UIActivityIndicatorView(style: .whiteLarge)
    var isLoadingEpisodes: Bool = false

    let channelProvider = DIContainer.shared.channelProvider
    var episodeCache = EpisodeCache()

    init(channel: Channel) {
        self.channel = channel

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 470, height: 270)

        //as recommended by https://developer.apple.com/tvos/human-interface-guidelines/visual-design/layout/
        layout.sectionInset = UIEdgeInsets(top: 60, left: 90, bottom: 60, right: 90)

        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView, initialSectionedValues: self.episodes)

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ChannelViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.view.addSubview(self.spinner)
        self.spinner.startAnimating()
        self.spinner.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        // Do any additional setup after loading the view.
        try? self.loadCachedSeries()
        self.reloadSeries()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.reloadSeries()
    }

    override var collectionViewLayout: UICollectionViewFlowLayout{
        return super.collectionViewLayout as! UICollectionViewFlowLayout
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.diffCalculator?.numberOfSections() ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diffCalculator?.numberOfObjects(inSection: section) ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChannelViewCell

        if let episode = self.diffCalculator?.value(atIndexPath: indexPath){
            cell.episode = episode
        }

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let episode = self.diffCalculator?.value(atIndexPath: indexPath) else {
            return
        }

        self.navigationController?.pushViewController(ChannelViewPlayer(withEpisode: episode), animated: true)
    }
}

// MARK: Data Loading
extension ChannelCollectionViewController {
    
    func loadCachedSeries() throws {
        let episodes = try episodeCache.getEpisodes(forChannel: self.channel)
        guard !episodes.isEmpty else {
            return
        }

        setEpisodes(episodes)
        self.spinner.removeFromSuperview()
    }

    func reloadSeries() {
        
        guard !self.isLoadingEpisodes else {
            debugPrint("Already loading series – skipping")
            return
        }

        isLoadingEpisodes = true

        channelProvider.getEpisodes(in: channel)
        .then(setEpisodes)
        .catch { (error) in
            let ac = UIAlertController(title: "Error Fetching Channel", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
        .always {
            self.isLoadingEpisodes = false
            self.tabBarItem.isEnabled = self.diffCalculator?.numberOfSections() ?? 0 > 0
            self.spinner.removeFromSuperview()
        }
    }
    
    private func setEpisodes(_ episodes: [ChannelEpisode]) {
        self.episodes = SectionedValues([("Episodes", episodes)])
        try? episodeCache.setEpisodes(episodes, forChannel: channel)
    }
}
