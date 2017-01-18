import UIKit

/*
 Mask indicating that a cell represents a video
 */
class VideoMaskView: UIView {
  private let durationLabel: UILabel
  private let gradient: CAGradientLayer
  private let videoIcon: UIImageView

  required override init(frame: CGRect) {
    self.durationLabel = UILabel(frame: CGRect.zero)
    self.gradient = CAGradientLayer()
    self.videoIcon = UIImageView(image: #imageLiteral(resourceName: "video-camera"))
    super.init(frame: CGRect.zero)
    setUpUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public API

  func set(_ duration: TimeInterval) {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = [.dropTrailing]
    formatter.allowedUnits = [.minute, .second]
    let componenetsString = formatter.string(from: duration)!
    durationLabel.text = "\(componenetsString)"
  }

  // MARK: Private UI

  private func setUpUI() {
    clipsToBounds = false

    // create gradient
    gradient.frame = bounds
    gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
    layer.insertSublayer(gradient, at: 0)

    let inset = SelectableCollectionViewCell.contentInset.left
    [durationLabel, videoIcon].forEach({ subview in
      subview.translatesAutoresizingMaskIntoConstraints = false
      addSubview(subview)
      subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
    })
    durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset).isActive = true
    videoIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset).isActive = true

    durationLabel.textColor = UIColor.white
    durationLabel.font = UIFont.systemFont(ofSize: 12)
    durationLabel.textAlignment = .right
    durationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: centerXAnchor).isActive = true
    durationLabel.adjustsFontSizeToFitWidth = true
    durationLabel.minimumScaleFactor = 0.8
  }
  
}
