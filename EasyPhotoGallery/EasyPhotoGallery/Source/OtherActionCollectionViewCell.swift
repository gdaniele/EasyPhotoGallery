import UIKit
import RxSwift

/*
 Delegate for `OtherActionCollectionViewCell
 */
protocol OtherActionCollectionViewCellDelegate: class {
  func didSelectAction(_ action: OtherActionCollectionViewCell.Action)
}

/*
 `UICollectionViewCell` representing an `Action`
 */
class OtherActionCollectionViewCell: UICollectionViewCell {
  weak var delegate: OtherActionCollectionViewCellDelegate?
  private let disposeBag: DisposeBag
  var action: Action? {
    didSet {
      guard let action = action else { return }
      imageView.image = action.image
    }
  }
  enum Action {
    case camera
    case library

    var image: UIImage {
      switch self {
      case .camera:
        return #imageLiteral(resourceName: "camera")
      case .library:
        return #imageLiteral(resourceName: "library")
      }
    }
  }
  private let imageView: UIImageView
  private let errorView: UIImageView

  override init(frame: CGRect) {
    self.disposeBag = DisposeBag()
    self.errorView = UIImageView(image: #imageLiteral(resourceName: "error-outline"))
    self.imageView = UIImageView(frame: CGRect.zero)
    super.init(frame: frame)
    setUpUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public API

  func toggleErrorState(_ on: Bool) {
    errorView.isHidden = !on
  }

  func didTapCell() {
    guard let action = action else { return }
    delegate?.didSelectAction(action)
  }

  // MARK: UI Set up

  private func setUpUI() {
    backgroundColor = UIColor.white
    let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    [imageView, errorView].forEach({ subview in
      errorView.isHidden = true
      subview.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(subview)
      subview.contentMode = .center
      subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
      subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right).isActive = true
    })

    imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
    imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true

    // Tap recognition
    let recognizer = UITapGestureRecognizer(target: self, action: nil)

    isUserInteractionEnabled = true
    addGestureRecognizer(recognizer)
    recognizer.addTarget(self, action: #selector(OtherActionCollectionViewCell.didTapCell))
  }
}
