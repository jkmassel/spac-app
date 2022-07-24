import UIKit

class ChannelViewCell: UICollectionViewCell {

    private let imageView = UIImageView(image: nil)
    private let label = UILabel(frame: .zero)

    private let cellLabelSize = CGSize(width: 470, height: 80)

    var episode: ChannelEpisode? {
        didSet{

            self.imageView.sd_setImage(with: episode?.imageUrl, placeholderImage: nil)
            self.imageView.adjustsImageWhenAncestorFocused = true

            self.label.text = episode?.title
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
                self.label.frame = CGRect(origin: CGPoint(x: 0, y: 240), size: self.cellLabelSize)
            }, completion: nil)
        }
        else{
            coordinator.addCoordinatedAnimations({
                self.label.frame = CGRect(origin: CGPoint(x: 0, y: 220), size: self.cellLabelSize)
            }, completion: nil)
        }
    }
}
