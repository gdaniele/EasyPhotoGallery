import AVFoundation
import Photos
import RxSwift

/*
 Controller for gallery UX (choose content to add to a collection)
 */
class GalleryViewController: UIViewController {
  // MARK: Data concerns
  fileprivate var dataSource: GalleryViewControllerDataSource
  fileprivate let imageManager: PHCachingImageManager
  fileprivate var galleryDataSource: GalleryDataSource? {
    return dataSource as? GalleryDataSource
  }
  // MARK: View concerns
  fileprivate var galleryView: GalleryView { return view as! GalleryView  }
  // MARK: Navigation
  fileprivate let navigator: GalleryNavigation
  private var thumbnailSize: CGSize
  // MARK: Service
  private let assetService: AssetService.Type = PHAssetService.self
  fileprivate var fetchResult: PHFetchResult<PHAsset>?
  // MARK: State
  fileprivate var selectedImage: UIImage? {
    didSet {
      if selectedImage == nil {
        navigationItem.rightBarButtonItem = nil
      } else {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(GalleryViewController.nextButtonPressed))
      }
    }
  }
  // MARK: Rx
  private let disposeBag: DisposeBag

  required init(navigator: GalleryNavigation) {
    self.dataSource = GalleryPreviewDataSource()
    self.disposeBag = DisposeBag()
    self.imageManager = PHCachingImageManager()
    self.navigator = navigator
    self.thumbnailSize = CGSize(width: 150, height: 150) // placeholder size until can be computed
    super.init(nibName: nil, bundle: nil)
    swapDataSourceIfNecessary()
    self.galleryView.galleryCollectionView.dataSource = self.dataSource
    setUpCollectionView()
    addApplicationActiveListeners()

    // nav controller set up
    navigationItem.leftBarButtonItem
      = UIBarButtonItem(barButtonSystemItem: .cancel,
                        target: self,
                        action: #selector(GalleryViewController.backButtonPressed))
  }

  convenience init(layout: GalleryViewLayout, navigator: GalleryNavigation) {
    self.init(navigator: navigator)
    galleryView.setLayout(layout)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
  }

  // MARK: Selectors

  func backButtonPressed() {
    navigator.navigateBack()
  }

  func nextButtonPressed() {
    guard let image = selectedImage else {
      return
    }
    navigator.navigateNext(image: image)
  }

  // MARK: UI

  override func loadView() {
    let galleryView = GalleryView()
    self.view = galleryView
  }

  private func setUpCollectionView() {
    galleryView.galleryCollectionView.register(SelectableCollectionViewCell.self,
                                               forCellWithReuseIdentifier: NSStringFromClass(SelectableCollectionViewCell.self))
    galleryView.galleryCollectionView.register(OtherActionCollectionViewCell.self,
                                               forCellWithReuseIdentifier: NSStringFromClass(OtherActionCollectionViewCell.self))

    galleryView.galleryCollectionView.delegate = self
    dataSource.actionCellDelegate = self
    dataSource.cellLayoutProvider = galleryView
  }

  /// Authorization concerns that result in redirect
  private func shouldRedirectToSettings() -> Bool {
    return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .denied &&
      PHPhotoLibrary.authorizationStatus() == .denied
  }

  // MARK: Set up

  /// Listens for UIApplicationDidBecomeActive notificiations
  private func addApplicationActiveListeners() {

    NotificationCenter.default.rx.notification(NSNotification.Name.UIApplicationDidBecomeActive)
      .subscribe({ [weak self] _ in
        guard let strongSelf = self else { return }
        // Redirects to app settings iff camera + library denied
        if strongSelf.shouldRedirectToSettings() {
          strongSelf.present(InadequatePermissionsAlertFactory.make(),
                             animated: true,
                             completion: nil)
        }
      }).addDisposableTo(disposeBag)
  }

  // MARK: Permissions

  /// Request photo library permissions
  fileprivate func requestLibraryPermissions() {
    PHPhotoLibrary.requestAuthorization({ [weak self] status in
      guard let strongSelf = self else { return }

      OperationQueue.main.addOperation({

        guard status == .authorized else {
          strongSelf.present(InadequatePermissionsAlertFactory.make(),
                             animated: true,
                             completion: nil)
          return
        }
        strongSelf.swapDataSourceIfNecessary()
      })
      })
  }

  // MARK: Data source changes

  /// Swaps out data source if photo library authorized
  private func swapDataSourceIfNecessary() {
    if PHPhotoLibrary.authorizationStatus() == .authorized {

      guard !(dataSource is GalleryDataSource) else {
        return
      }
      guard let collection = assetService.getCameraRollCollection() else {
        return
      }
      fetchResult = assetService.getCameraRollAssets()
      dataSource = GalleryDataSource(assetCollection: collection,
                                     fetchResults: fetchResult!)
      dataSource.actionCellDelegate = self
      dataSource.cellLayoutProvider = galleryView
      PHPhotoLibrary.shared().register(self)
      galleryView.galleryCollectionView.dataSource = dataSource
    } else {
      PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
  }
}

/*
 `OtherActionCollectionViewCellDelegate` interface for `GalleryViewController`
 */
extension GalleryViewController: OtherActionCollectionViewCellDelegate {
  func didSelectAction(_ action: OtherActionCollectionViewCell.Action) {
    switch action {
    case .library:
      requestLibraryPermissions()
    default:
      navigator.navigateToCapture(self)
    }
  }
}

// MARK: UICollectionViewDelegate

extension GalleryViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    if indexPath.item < dataSource.firstSelectableItem.item {
      return false
    }
    return true
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let asset = galleryDataSource?.fetchResult.object(at: indexPath.item) {
      imageManager.requestImage(for: asset,
                                targetSize: CGSize(width: 500, height: 500),
                                contentMode: .aspectFill,
                                options: nil,
                                resultHandler: { result, info in
                                  guard let image = result else { return }
                                  self.selectedImage = image
      })
    }
  }
}

// MARK: PHPhotoLibraryChangeObserver
extension GalleryViewController: PHPhotoLibraryChangeObserver {

  func photoLibraryDidChange(_ changeInstance: PHChange) {

    guard let changes = changeInstance.changeDetails(for: fetchResult as! PHFetchResult<AnyObject> as! PHFetchResult<PHObject>)
      else { return }

    // Change notifications may be made on a background queue. Re-dispatch to the
    // main queue before acting on the change as we'll be updating the UI.
    DispatchQueue.main.sync {
      // Hang on to the new fetch result.
      fetchResult = changes.fetchResultAfterChanges as? PHFetchResult<PHAsset>
      guard let galleryDataSource = galleryDataSource else { return }
      galleryDataSource.fetchResult = fetchResult!
      let collectionView = galleryView.galleryCollectionView
      if changes.hasIncrementalChanges {

        // If we have incremental diffs, animate them in the collection view.
        collectionView.performBatchUpdates({
          // For indexes to make sense, updates must be in this order:
          // delete, insert, reload, move
          let fetchResultsCollectionViewOffset: Int = GalleryDataSource.ContentSectionNonSelectableRow.count
          if let removed = changes.removedIndexes, removed.count > 0 {
            collectionView.deleteItems(at: removed.map({ IndexPath(item: $0 + fetchResultsCollectionViewOffset, section: 0) }))
          }
          if let inserted = changes.insertedIndexes, inserted.count > 0 {
            collectionView.insertItems(at: inserted.map({ IndexPath(item: $0 + fetchResultsCollectionViewOffset, section: 0) }))
          }
          if let changed = changes.changedIndexes, changed.count > 0 {
            collectionView.reloadItems(at: changed.map({ IndexPath(item: $0 + fetchResultsCollectionViewOffset, section: 0) }))
          }
          changes.enumerateMoves { fromIndex, toIndex in
            collectionView.moveItem(at: IndexPath(item: fromIndex + fetchResultsCollectionViewOffset, section: 0),
                                    to: IndexPath(item: toIndex + fetchResultsCollectionViewOffset, section: 0))
          }
          collectionView.reloadData()
        })
      } else {
        // Reload the collection view if incremental diffs are not available.
        collectionView.reloadData()
      }
    }
  }
}
