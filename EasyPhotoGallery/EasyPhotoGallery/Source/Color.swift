import UIKit

// Color concerns
protocol Color {
  static var magenta: UIColor { get }
}

struct AlphaColor: Color {
  static let black = UIColor.black
  static let gray20 = UIColor.lightGray
  static let gray80 = UIColor(red: 0.97, green: 0.96, blue: 0.98, alpha: 1.0)
  static let lightBlue = UIColor(red: 0.27, green: 0.50, blue: 0.84, alpha: 1.0)
  static let magenta = UIColor(red: 0.82, green: 0.00, blue: 0.32, alpha: 1.0)
  static let white = UIColor.white
}
