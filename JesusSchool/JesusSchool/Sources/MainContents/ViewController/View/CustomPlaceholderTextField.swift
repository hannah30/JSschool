
import UIKit

class CustomPlaceholderTextField: UITextField {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds,
                                 UIEdgeInsetsMake(0, 15, 0, 15))
  }
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds,
                                 UIEdgeInsetsMake(0, 15, 0, 15))
  }
}
