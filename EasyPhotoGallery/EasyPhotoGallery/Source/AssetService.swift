import Photos
import RxSwift

/*
 Interface completing operations on photo libraries
 */
protocol AssetService {
  static func getLatestImage(size: CGSize, completion: @escaping (UIImage?) -> ())
  static func getCameraRollAssets() -> PHFetchResult<PHAsset>
  static func getCameraRollCollection() -> PHAssetCollection?
}

/*
 Photos framework `AssetService
 */
struct PHAssetService: AssetService {

  static func getCameraRollAssets() -> PHFetchResult<PHAsset> {
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false,
                                              selector: nil)]
    let cameraRollCollection = getCameraRollCollection()
    guard let cameraRoll = cameraRollCollection else { fatalError() }
    let cameraRollAssets = PHAsset.fetchAssets(in: cameraRoll,
                                               options: options)
    return cameraRollAssets
  }

  static func getCameraRollCollection() -> PHAssetCollection? {
    return PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                   subtype: .smartAlbumUserLibrary,
                                                   options: nil).firstObject
  }

  static func getLatestImage(size: CGSize, completion: @escaping (UIImage?) -> ()) {
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false,
                                              selector: nil)]

    let result = PHAsset.fetchAssets(with: .image,
                                     options: options)
    guard let last = result.lastObject else {
      completion(nil)
      return
    }

    let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
    requestOptions.version = .current

    PHImageManager.default().requestImage(for: last,
                                          targetSize: size,
                                          contentMode: PHImageContentMode.aspectFit,
                                          options: requestOptions,
                                          resultHandler: { image, info in
                                            DispatchQueue.main.async(execute: {
                                              completion(image)
                                            })
    })
  }
}
