import Foundation

protocol GalleryNavigation {
  func navigateNext(image: UIImage)
  func navigateBack()
  func navigateToCapture(_ from: GalleryViewController)
}
