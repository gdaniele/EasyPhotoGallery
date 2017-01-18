import AVFoundation
import Photos
import RxCocoa
import UIKit

/*
 Data source for `GalleryViewController
 */
protocol GalleryViewControllerDataSource: class, UICollectionViewDataSource, SectionedViewDataSourceType {
  weak var actionCellDelegate: OtherActionCollectionViewCellDelegate? { get set }
  weak var cellLayoutProvider: GalleryCellLayoutProvider? { get set }
  var firstSelectableItem: IndexPath { get }
}

/*
 Data source for `GalleryViewController` showing a gallery preview (used when photo library
 permissions are denied)
 */
class GalleryPreviewDataSource: NSObject, UICollectionViewDataSource, GalleryViewControllerDataSource {
  weak var actionCellDelegate: OtherActionCollectionViewCellDelegate?
  weak var cellLayoutProvider: GalleryCellLayoutProvider?
  private(set) var firstSelectableItem: IndexPath

  enum Sections: Int {
    case content = 0

    static let count = 1
  }

  enum ContentSectionNonSelectableRow: Int {
    case camera = 0
    case library = 1

    static let count = 2
  }

  enum DeviceSourceState {
    case camera
    case cameraAndPhotoLibrary
    case photoLibrary
    case none

    var sourceCount: Int {
      switch self {
      case .camera: return 1
      case .cameraAndPhotoLibrary: return 2
      case .photoLibrary: return 1
      case .none: return 0
      }
    }
  }

  private var devicesState: DeviceSourceState = {
    let cameraSupported: Bool = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    let librarySupported: Bool = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)

    switch (cameraSupported, librarySupported) {
    case (true, true):
      return .cameraAndPhotoLibrary
    case (false, true):
      return .photoLibrary
    case (true, false):
      return .camera
    case (false, false):
      return .none
    }
  }()

  override init() {
    self.firstSelectableItem = IndexPath(row: devicesState.sourceCount,
                                    section: Sections.content.rawValue)
    super.init()
  }

  // MARK: UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return devicesState.sourceCount
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Sections.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    switch devicesState {
    case .none:
      fatalError("Device does not support any source and this index path is invalid")
    case .camera:
      return cellForCameraItem(indexPath: indexPath, collectionView: collectionView)
    case .cameraAndPhotoLibrary:
      switch indexPath.item {
      case ContentSectionNonSelectableRow.camera.rawValue:
        return cellForCameraItem(indexPath: indexPath, collectionView: collectionView)
      case ContentSectionNonSelectableRow.library.rawValue:
        return cellForLibraryItem(indexPath: indexPath, collectionView: collectionView)
      default: fatalError("not correct index path")
      }
    case .photoLibrary:
      return cellForLibraryItem(indexPath: indexPath, collectionView: collectionView)
    }
  }

  private func cellForCameraItem(indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
    guard let cell = collectionView
      .dequeueReusableCell(withReuseIdentifier: NSStringFromClass(OtherActionCollectionViewCell.self),
                           for: indexPath) as? OtherActionCollectionViewCell else { fatalError() }
    cell.action = .camera
    cell.delegate = actionCellDelegate

    let cameraDenied = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .denied
    cell.toggleErrorState(cameraDenied)

    return cell
  }

  private func cellForLibraryItem(indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
    guard let cell = collectionView
      .dequeueReusableCell(withReuseIdentifier: NSStringFromClass(OtherActionCollectionViewCell.self),
                           for: indexPath) as? OtherActionCollectionViewCell else { fatalError() }
    cell.action = .library
    cell.delegate = actionCellDelegate
    let libraryDenied = PHPhotoLibrary.authorizationStatus() == .denied
    cell.toggleErrorState(libraryDenied)

    return cell
  }
}

/*
 `SectionedViewDataSourceType` extension of `GalleryPreviewDataSource
 */
extension GalleryPreviewDataSource: SectionedViewDataSourceType {
  enum GalleryDataModelError: Error {
    case notAModel
  }
  func model(at indexPath: IndexPath) throws -> Any {
    throw GalleryDataModelError.notAModel
  }
}
