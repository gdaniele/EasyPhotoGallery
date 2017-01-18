import UIKit
import EasyPhotoGallery

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let layout = GalleryViewLayout(cellsAcross: 3, interitemSpacing: 4, lineSpacing: 6)
    window?.rootViewController = GalleryRootContainerViewController(layout: layout)
    window?.makeKeyAndVisible()

    return true
  }
}
