import UIKit

/*
 Navigation bar with title `GalleryViewController`
 */
class GalleryNavigationBar: UIView {
  private var bottomBorder: CALayer!
  private let titleLabel: UILabel
  private let backButton: UIButton
  private let nextButton: UIButton

  override init(frame: CGRect) {
    self.backButton = UIButton(type: .system)
    self.nextButton = UIButton(type: .system)
    self.titleLabel = UILabel(frame: CGRect.zero)
    super.init(frame: frame)
    setUpUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIScreen.main.bounds.size.width, height: 68)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    if frame != CGRect.zero {
      if bottomBorder == nil {
        bottomBorder = CALayer()
        layer.addSublayer(bottomBorder)
      }
      bottomBorder.backgroundColor = UIColor.black.cgColor
      bottomBorder.frame = CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5)
    }
  }

  // MARK: Set up UI

  private func setUpUI() {
    titleLabel.font = AlphaFont.title3
    titleLabel.text = "Profile picture"
    titleLabel.textColor = AlphaColor.magenta
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(titleLabel)

    titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
  }
}
