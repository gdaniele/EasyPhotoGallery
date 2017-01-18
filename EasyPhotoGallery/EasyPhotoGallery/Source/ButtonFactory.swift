import UIKit

/*
 Button with a solid black top border
 */
class TopBorderButton: UIButton {
  private var topBorder: CALayer? = nil

  override func layoutSubviews() {
    super.layoutSubviews()

    if frame != CGRect.zero {
      guard let topBorder = topBorder else {
        self.topBorder = CALayer()
        self.topBorder?.backgroundColor = UIColor.black.cgColor
        self.topBorder?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 1)
        layer.addSublayer(self.topBorder!)
        return
      }
      topBorder.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 2)
    }
  }
}

/*
 Factory for UIButton styles
 */
struct ButtonFactory {
  static func createButton() -> UIButton {
    let button = TopBorderButton(type: .system)
    button.backgroundColor = UIColor.white
    button.setTitleColor(UIColor.black, for: UIControlState())
    button.contentEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0)
    button.titleLabel?.font = AlphaFont.headline

    return button
  }
}
