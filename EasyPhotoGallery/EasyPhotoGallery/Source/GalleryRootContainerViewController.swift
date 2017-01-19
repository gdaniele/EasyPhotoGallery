import UIKit

/**
 `GalleryRootContainerViewControllerDelegate` is the delegate for `GalleryRootContainerViewController`
 */
public protocol GalleryRootContainerViewControllerDelegate: class {
  func didPickImage(galleryRootContainerViewController: GalleryRootContainerViewController,
                    image: UIImage)
  func didDismiss(galleryRootContainerViewController: GalleryRootContainerViewController)
}

/**
 `GalleryRootContainerViewController` is a container for `EasyPhotoGallery` and implements its
 navigation concerns
 */
public class GalleryRootContainerViewController: UIViewController {
  public weak var delegate: GalleryRootContainerViewControllerDelegate?
  fileprivate weak var onScreenViewController: UIViewController?
  private var layout: GalleryViewLayout? = nil
  private var navigationBarTitle: String?

  public convenience init(layout: GalleryViewLayout, navigationBarTitle: String) {
    self.init(nibName: nil, bundle: nil)
    self.layout = layout
    self.navigationBarTitle = navigationBarTitle
  }

  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return onScreenViewController?.preferredStatusBarStyle ?? .lightContent
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    let galleryViewController: GalleryViewController
    if let layout = layout {
      galleryViewController = GalleryViewController(layout: layout, navigator: self)
    } else {
      galleryViewController = GalleryViewController(navigator: self)
    }
    galleryViewController.title = navigationBarTitle
    let navController = UINavigationController(rootViewController: galleryViewController)
    navController.navigationBar.tintColor = UIColor.black
    navigateTo(destination: navController)
  }

  // MARK: Private navigation

  /// Navigates to `viewController` via view controller containment
  fileprivate func navigateTo<T: UIViewController>(destination: T) {
    for subview in view.subviews {
      subview.removeFromSuperview()
    }
    onScreenViewController?.dismiss(animated: true, completion: nil)
    onScreenViewController = destination

    destination.willMove(toParentViewController: self)
    addChildViewController(destination)
    view.addSubview(destination.view)
    destination.didMove(toParentViewController: self)
    destination.view.frame = view.frame

    setNeedsStatusBarAppearanceUpdate()
  }
}

/**
 `GalleryNavigation` implementation for `GalleryRootContainerViewController`
 */
extension GalleryRootContainerViewController: GalleryNavigation {
  func navigateToCapture(_ from: GalleryViewController) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .camera
    from.present(imagePicker, animated: true, completion: nil)
  }

  func navigateBack() {
    delegate?.didDismiss(galleryRootContainerViewController: self)
  }

  func navigateNext(image: UIImage) {
    delegate?.didPickImage(galleryRootContainerViewController: self, image: image)
  }
}

/**
 
 */
extension GalleryRootContainerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    picker.dismiss(animated: true, completion: nil)
  }
}
