import UIKit
import EasyPhotoGallery

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let layout = GalleryViewLayout(cellsAcross: 3, interitemSpacing: 4, lineSpacing: 6)
    let galleryVC = GalleryRootContainerViewController(layout: layout, navigationBarTitle: "Choose a picture")
    galleryVC.delegate = self
    window?.rootViewController = galleryVC
    window?.makeKeyAndVisible()

    return true
  }
}

extension AppDelegate: GalleryRootContainerViewControllerDelegate {
  func didPickImage(galleryRootContainerViewController: GalleryRootContainerViewController, image: UIImage) {
    print("pick it dude")
  }

  func didDismiss(galleryRootContainerViewController: GalleryRootContainerViewController) {
    print("Dismiss")
  }
}
