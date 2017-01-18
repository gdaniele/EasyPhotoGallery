import AVFoundation
import Photos
import RxCocoa
import UIKit

/*
 Data source for `GalleryViewController` showing a gallery preview of given collection
 */
class GalleryDataSource: NSObject, UICollectionViewDataSource, GalleryViewControllerDataSource {
  weak var actionCellDelegate: OtherActionCollectionViewCellDelegate?
  weak var cellLayoutProvider: GalleryCellLayoutProvider?
  // MARK: Image cache/manager
  private let assetCollection: PHAssetCollection
  var fetchResult: PHFetchResult<PHAsset> // can be changed (e.g. user takes new photo)
  fileprivate let imageManager: PHCachingImageManager

  private(set) var firstSelectableItem: IndexPath

  enum Sections: Int {
    case content = 0

    static let count = 1
  }

  enum ContentSectionNonSelectableRow: Int {
    case camera = 0

    static let count = 1
  }

  required init(assetCollection: PHAssetCollection,
                fetchResults: PHFetchResult<PHAsset>) {
    self.assetCollection = assetCollection
    self.fetchResult = fetchResults
    let firstSelectableIndex: Int = UIImagePickerController.isSourceTypeAvailable(.camera)
      ? 1 : 0
    self.firstSelectableItem = IndexPath(row: firstSelectableIndex,
                                         section: Sections.content.rawValue)
    self.imageManager = PHCachingImageManager()
    super.init()
    PHPhotoLibrary.shared().register(self)
  }

  deinit {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
  }

  // MARK: UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      return ContentSectionNonSelectableRow.count + fetchResult.count
    } else {
      return fetchResult.count
    }
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Sections.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if UIImagePickerController.isSourceTypeAvailable(.camera)
      && indexPath.item == ContentSectionNonSelectableRow.camera.rawValue {
      guard let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: NSStringFromClass(OtherActionCollectionViewCell.self),
                             for: indexPath) as? OtherActionCollectionViewCell else { fatalError() }
      cell.action = .camera
      cell.delegate = actionCellDelegate

      let cameraDenied = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .denied
      cell.toggleErrorState(cameraDenied)

      return cell
    } else {
      let assetIndex = UIImagePickerController.isSourceTypeAvailable(.camera)
        ? indexPath.item - ContentSectionNonSelectableRow.count
        : indexPath.item
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(SelectableCollectionViewCell.self),
                                                          for: indexPath) as? SelectableCollectionViewCell else {
                                                            fatalError() }
      let asset = fetchResult.object(at: assetIndex)

      cell.assetIdentifier = asset.localIdentifier

      var itemSize: CGSize
      if let fetchedItemSize = cellLayoutProvider?.itemSize {
        itemSize = fetchedItemSize
      } else {
        itemSize = CGSize(width: 150, height: 150)
      }
      imageManager.requestImage(for: asset,
                                targetSize: itemSize,
                                contentMode: .aspectFill,
                                options: nil,
                                resultHandler: { result, info in
                                  guard let image = result else { return }
                                  if cell.assetIdentifier == asset.localIdentifier {
                                    if asset.mediaType == .video {
                                      cell.set(videoPreview: image, duration: asset.duration)
                                      return
                                    }
                                    cell.set(image: image)
                                  }
      })

      return cell
    }
  }
}

/*
 `SectionedViewDataSourceType` extension of `GalleryDataSource`
 */
extension GalleryDataSource: SectionedViewDataSourceType {
  enum GalleryDataModelError: Error {
    case notAModel
  }
  func model(at indexPath: IndexPath) throws -> Any {
    return indexPath.item
  }
}

/*
 `PHPhotoLibraryChangeObserver` extension of `GalleryDataSource`
 */
extension GalleryDataSource: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    imageManager.stopCachingImagesForAllAssets()
  }
}
