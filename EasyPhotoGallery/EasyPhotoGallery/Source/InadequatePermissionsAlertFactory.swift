import UIKit

/*
 Factory for alert used when permissions are inadequate
 */
struct InadequatePermissionsAlertFactory {
  static func make() -> UIAlertController {
    let alert = UIAlertController(title: "Use your camera and library?",
                                  message: "Camera and/or photo library permissions are needed to choose an image",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes",
                                  style: .default,
                                  handler: { (action) in
                                    guard let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) as? URL else { return }
                                    UIApplication.shared.openURL(settingsURL)
    }))
    return alert
  }
}
