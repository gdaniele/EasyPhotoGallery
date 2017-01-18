import UIKit

/**
 `GalleryRootContainerViewController` is a container for `EasyPhotoGallery` and implements its
 navigation concerns
 */
public class GalleryRootContainerViewController: UIViewController {
  fileprivate weak var onScreenViewController: UIViewController?
  private var layout: GalleryViewLayout? = nil

  public convenience init(layout: GalleryViewLayout) {
    self.init(nibName: nil, bundle: nil)
    self.layout = layout
  }

  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return onScreenViewController?.preferredStatusBarStyle ?? .lightContent
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    if let layout = layout {
      navigateTo(destination: GalleryViewController(layout: layout, navigator: self))
    } else {
      navigateTo(destination: GalleryViewController(navigator: self))
    }
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
  public func navigateToCapture(_ from: GalleryViewController) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .camera
    from.present(imagePicker, animated: true, completion: nil)
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
