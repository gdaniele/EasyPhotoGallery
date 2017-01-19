import UIKit

/*
 `UICollectionViewCell` representing a photo or video
 */
class SelectableCollectionViewCell: UICollectionViewCell {
  /// identifier of asset currently being displayed
  var assetIdentifier: String?
  private let previewView: UIImageView
  private let videoMask: VideoMaskView

  static let contentInset = UIEdgeInsetsMake(3, 3, 3, 3)

  private var assetType: AssetType = .image

  enum AssetType {
    case image
    case video
  }

  override var isSelected: Bool {
    didSet {
      animate(selected: isSelected)
    }
  }

  // MARK: Initialization

  override init(frame: CGRect) {
    self.previewView = UIImageView(frame: CGRect.zero)
    self.videoMask = VideoMaskView(frame: CGRect.zero)
    super.init(frame: CGRect.zero)
    setUpUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    previewView.image = nil
    transitionToImageType(.image)
  }

  // MARK: Public API

  func set(image: UIImage) {
    previewView.image = image
    previewView.contentMode = .scaleAspectFill
    transitionToImageType(.image)
  }

  func set(videoPreview: UIImage, duration: TimeInterval) {
    previewView.image = videoPreview
    previewView.contentMode = .scaleAspectFill
    transitionToImageType(.video)
    videoMask.set(duration)
  }

  // MARK: UI

  func animate(selected: Bool) {
    if selected {
      let animation = CABasicAnimation(keyPath: "borderColor")
      let blue = UIColor(red: 0.27, green: 0.50, blue: 0.84, alpha: 1.0)
      animation.fromValue = UIColor.clear.cgColor
      animation.toValue = blue.cgColor
      animation.duration = 0.2
      layer.add(animation, forKey: "borderColorAnimation")
      layer.borderColor = blue.cgColor
    } else {
      layer.borderColor = UIColor.clear.cgColor
    }
  }

  private func transitionToImageType(_ type: AssetType) {
    guard self.assetType != type else { return }
    videoMask.isHidden = type != .video
    assetType = type
  }

  private func setUpUI() {
    layer.borderColor = UIColor.clear.cgColor
    layer.borderWidth = 3.5
    [previewView, videoMask].forEach({ subview in
      subview.translatesAutoresizingMaskIntoConstraints = false

      contentView.addSubview(subview)
    })

    [videoMask].forEach({ pinnedToBottomLeft in
      pinnedToBottomLeft.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
      pinnedToBottomLeft.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    })

    videoMask.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

    previewView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    previewView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    previewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    previewView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    previewView.clipsToBounds = true
    videoMask.isHidden = assetType != .video
  }
}
