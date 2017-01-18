import UIKit
import RxCocoa
import RxSwift

/*
 Protocol for communicating `itemSize`
 */
protocol GalleryCellLayoutProvider: class {
  var itemSize: CGSize? { get set }
}

public struct GalleryViewLayout {
  let cellsAcross: CGFloat
  let interitemSpacing: CGFloat
  let lineSpacing: CGFloat

  public init(cellsAcross: CGFloat, interitemSpacing: CGFloat, lineSpacing: CGFloat) {
    self.cellsAcross = cellsAcross
    self.interitemSpacing = interitemSpacing
    self.lineSpacing = lineSpacing
  }
}

/*
 View concerns for `GalleryViewController`
 */
class GalleryView: UIView, GalleryCellLayoutProvider {
  // MARK: Rx
  private let disposeBag: DisposeBag
  private let galleryCollectionViewLayout: UICollectionViewFlowLayout
  // MARK: Layout
  var itemSize: CGSize?
  // MARK: UI
  let galleryCollectionView: UICollectionView
  private let navigationBar: GalleryNavigationBar
  private var layout: GalleryViewLayout = GalleryViewLayout(cellsAcross: 3, interitemSpacing: 2, lineSpacing: 2)

  override init(frame: CGRect) {
    self.disposeBag = DisposeBag()
    self.galleryCollectionViewLayout = UICollectionViewFlowLayout()
    self.galleryCollectionView = UICollectionView(frame: CGRect.zero,
                                                  collectionViewLayout: galleryCollectionViewLayout)
    self.navigationBar = GalleryNavigationBar()
    super.init(frame: frame)
    setUpUI()
    setUpCollectionViewLayout()
  }

  override var intrinsicContentSize: CGSize {
    return UIScreen.main.bounds.size
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  func setLayout(_ layout: GalleryViewLayout) {
    self.layout = layout
    setCollectionViewLayout()
  }

  // MARK: UI

  private func setUpUI() {
    backgroundColor = UIColor.white.withAlphaComponent(0.99)
    galleryCollectionView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    galleryCollectionView.alwaysBounceVertical = true

    [galleryCollectionView, navigationBar].forEach({ subview in
      subview.translatesAutoresizingMaskIntoConstraints = false
      addSubview(subview)
    })
    navigationBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
    galleryCollectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true

    let bottomAnchorConstraint = galleryCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    bottomAnchorConstraint.priority = UILayoutPriorityDefaultHigh
    bottomAnchorConstraint.isActive = true

    [galleryCollectionView, navigationBar].forEach({ sidePinnedView in
      sidePinnedView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
      sidePinnedView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    })
  }

  private func setUpCollectionViewLayout() {
    galleryCollectionViewLayout.minimumInteritemSpacing = layout.interitemSpacing
    // For some reason, dispatching main queue is necessary
    // http://stackoverflow.com/a/32175929
    DispatchQueue.main.async { [weak self] in
      if let spacing = self?.layout.lineSpacing {
        self?.galleryCollectionViewLayout.minimumLineSpacing = spacing
      }
    }
    galleryCollectionView.contentInset = UIEdgeInsetsMake(layout.interitemSpacing,
                                                          layout.interitemSpacing,
                                                          layout.interitemSpacing,
                                                          layout.interitemSpacing)

    galleryCollectionView.rx.observe(CGRect.self, "bounds")
      .flatMapLatest({ bounds -> Observable<CGFloat> in
        guard let bounds = bounds else { return Observable.never() }
        return Observable.just(bounds.size.width)
      })
      .distinctUntilChanged()
      .filter({ $0 > 0.0 })
      .subscribe({ [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.setCollectionViewLayout()
      }).addDisposableTo(disposeBag)
  }

  // MARK: Private - Bounds-dependent layout

  private func setCollectionViewLayout() {
    let fixedWidth = floor(((galleryCollectionView.frame.size.width
      - (layout.interitemSpacing
        * layout.cellsAcross + 1))
      / layout.cellsAcross))

    itemSize = CGSize(width: fixedWidth, height: fixedWidth)
    galleryCollectionViewLayout.itemSize = itemSize!
  }
  
}
