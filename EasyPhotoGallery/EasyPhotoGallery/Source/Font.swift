import UIKit

/*
 Font concerns
 */
protocol Font {
  static var title1 : UIFont { get set }
  static var title2 : UIFont { get set }
  static var title3 : UIFont { get set }
  static var headline : UIFont { get set }
  static var subheadline : UIFont { get set }
  static var body : UIFont { get set }
  static var callout : UIFont { get set }
  static var footnote : UIFont { get set }
  static var caption1 : UIFont { get set }
  static var caption2 : UIFont { get set }
}

struct AlphaFont: Font {
  static var title1      = UIFont.preferredAvenirBoldFont(forTextStyle: UIFontTextStyle.title1.rawValue)
  static var title2      = UIFont.preferredAvenirBoldFont(forTextStyle: UIFontTextStyle.title2.rawValue)
  static var title3      = UIFont.preferredAvenirBoldFont(forTextStyle: UIFontTextStyle.title3.rawValue)
  static var headline    = UIFont.preferredAvenirFont(forTextStyle: UIFontTextStyle.headline.rawValue)
  static var subheadline = UIFont.preferredAvenirFont(forTextStyle: UIFontTextStyle.subheadline.rawValue)
  static var body        = UIFont.preferredAvenirFont(forTextStyle: UIFontTextStyle.body.rawValue)
  static var callout     = UIFont.preferredAvenirFont(forTextStyle: UIFontTextStyle.callout.rawValue)
  static var footnote    = UIFont.preferredAvenirFont(forTextStyle: UIFontTextStyle.footnote.rawValue)
  static var caption1    = UIFont.preferredAvenirFont(forTextStyle: UIFontTextStyle.caption1.rawValue)
  static var caption2    = UIFont.preferredAvenirFont(forTextStyle: UIFontTextStyle.caption2.rawValue)
}
