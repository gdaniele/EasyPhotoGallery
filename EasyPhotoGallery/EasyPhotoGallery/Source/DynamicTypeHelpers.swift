import UIKit

// `UIFont` extension to support Avenir traits
extension UIFont {
  private static let preferredBoldFontName = "Avenir-Heavy"
  private static let preferredFontName = "Avenir"
  private static var fontSizeTable: [String: [UIContentSizeCategory: CGFloat]] {
    return [
      UIFontTextStyle.title1.rawValue:[
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 26,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 25,
        UIContentSizeCategory.accessibilityExtraLarge: 24,
        UIContentSizeCategory.accessibilityLarge: 24,
        UIContentSizeCategory.accessibilityMedium: 23,
        UIContentSizeCategory.extraExtraExtraLarge: 23,
        UIContentSizeCategory.extraExtraLarge: 22,
        UIContentSizeCategory.extraLarge: 21,
        UIContentSizeCategory.large: 30,
        UIContentSizeCategory.medium: 28,
        UIContentSizeCategory.small: 27,
        UIContentSizeCategory.extraSmall: 26],
      UIFontTextStyle.title2.rawValue:[
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 26,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 25,
        UIContentSizeCategory.accessibilityExtraLarge: 24,
        UIContentSizeCategory.accessibilityLarge: 24,
        UIContentSizeCategory.accessibilityMedium: 23,
        UIContentSizeCategory.extraExtraExtraLarge: 23,
        UIContentSizeCategory.extraExtraLarge: 22,
        UIContentSizeCategory.extraLarge: 21,
        UIContentSizeCategory.large: 26,
        UIContentSizeCategory.medium: 24,
        UIContentSizeCategory.small: 23,
        UIContentSizeCategory.extraSmall: 22],
      UIFontTextStyle.title3.rawValue:[
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 26,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 25,
        UIContentSizeCategory.accessibilityExtraLarge: 24,
        UIContentSizeCategory.accessibilityLarge: 24,
        UIContentSizeCategory.accessibilityMedium: 23,
        UIContentSizeCategory.extraExtraExtraLarge: 23,
        UIContentSizeCategory.extraExtraLarge: 22,
        UIContentSizeCategory.extraLarge: 21,
        UIContentSizeCategory.large: 24,
        UIContentSizeCategory.medium: 23,
        UIContentSizeCategory.small: 22,
        UIContentSizeCategory.extraSmall: 21],
      UIFontTextStyle.headline.rawValue:[
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 26,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 25,
        UIContentSizeCategory.accessibilityExtraLarge: 24,
        UIContentSizeCategory.accessibilityLarge: 24,
        UIContentSizeCategory.accessibilityMedium: 23,
        UIContentSizeCategory.extraExtraExtraLarge: 23,
        UIContentSizeCategory.extraExtraLarge: 22,
        UIContentSizeCategory.extraLarge: 21,
        UIContentSizeCategory.large: 20,
        UIContentSizeCategory.medium: 19,
        UIContentSizeCategory.small: 18,
        UIContentSizeCategory.extraSmall: 17],
      UIFontTextStyle.subheadline.rawValue:[
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 24,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 23,
        UIContentSizeCategory.accessibilityExtraLarge: 22,
        UIContentSizeCategory.accessibilityLarge: 22,
        UIContentSizeCategory.accessibilityMedium: 21,
        UIContentSizeCategory.extraExtraExtraLarge: 21,
        UIContentSizeCategory.extraExtraLarge: 20,
        UIContentSizeCategory.extraLarge: 19,
        UIContentSizeCategory.large: 18,
        UIContentSizeCategory.medium: 17,
        UIContentSizeCategory.small: 16,
        UIContentSizeCategory.extraSmall: 15],
      UIFontTextStyle.body.rawValue:[
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 21,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 20,
        UIContentSizeCategory.accessibilityExtraLarge: 19,
        UIContentSizeCategory.accessibilityLarge: 19,
        UIContentSizeCategory.accessibilityMedium: 18,
        UIContentSizeCategory.extraExtraExtraLarge: 18,
        UIContentSizeCategory.extraExtraLarge: 17,
        UIContentSizeCategory.extraLarge: 16,
        UIContentSizeCategory.large: 15,
        UIContentSizeCategory.medium: 14,
        UIContentSizeCategory.small: 13,
        UIContentSizeCategory.extraSmall: 12],
      UIFontTextStyle.caption1.rawValue:[
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 19,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 18,
        UIContentSizeCategory.accessibilityExtraLarge: 17,
        UIContentSizeCategory.accessibilityLarge: 17,
        UIContentSizeCategory.accessibilityMedium: 16,
        UIContentSizeCategory.extraExtraExtraLarge: 16,
        UIContentSizeCategory.extraExtraLarge: 16,
        UIContentSizeCategory.extraLarge: 15,
        UIContentSizeCategory.large: 14,
        UIContentSizeCategory.medium: 13,
        UIContentSizeCategory.small: 12,
        UIContentSizeCategory.extraSmall: 12],
      UIFontTextStyle.caption2.rawValue:[
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 18,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 17,
        UIContentSizeCategory.accessibilityExtraLarge: 16,
        UIContentSizeCategory.accessibilityLarge: 16,
        UIContentSizeCategory.accessibilityMedium: 15,
        UIContentSizeCategory.extraExtraExtraLarge: 15,
        UIContentSizeCategory.extraExtraLarge: 14,
        UIContentSizeCategory.extraLarge: 14,
        UIContentSizeCategory.large: 13,
        UIContentSizeCategory.medium: 12,
        UIContentSizeCategory.small: 12,
        UIContentSizeCategory.extraSmall: 11],
      UIFontTextStyle.footnote.rawValue:[
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 16,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 15,
        UIContentSizeCategory.accessibilityExtraLarge: 14,
        UIContentSizeCategory.accessibilityLarge: 14,
        UIContentSizeCategory.accessibilityMedium: 13,
        UIContentSizeCategory.extraExtraExtraLarge: 13,
        UIContentSizeCategory.extraExtraLarge: 12,
        UIContentSizeCategory.extraLarge: 12,
        UIContentSizeCategory.large: 11,
        UIContentSizeCategory.medium: 11,
        UIContentSizeCategory.small: 10,
        UIContentSizeCategory.extraSmall: 10]
    ]
  }

  class func preferredAvenirBoldFont(forTextStyle textStyle: String) -> UIFont {
    let contentSize = UIApplication.shared.preferredContentSizeCategory
    guard let computedSize = fontSizeTable[textStyle]?[contentSize] else { fatalError() }
    return UIFont(name: preferredBoldFontName, size: computedSize)!
  }

  class func preferredAvenirFont(forTextStyle textStyle: String) -> UIFont {
    let contentSize = UIApplication.shared.preferredContentSizeCategory
    guard let computedSize = fontSizeTable[textStyle]?[contentSize] else { fatalError() }
    return UIFont(name: preferredFontName, size: computedSize)!
  }
}
