
// 글자자간 및 줄 간격 넓히기

import UIKit

@IBDesignable

class KeringLabel: UILabel {
  
  @IBInspectable var kerning:CGFloat = 0.0{
    didSet {
      if ((self.attributedText?.length) != nil) {
        let attribString = NSMutableAttributedString(attributedString: self.attributedText!)
        attribString.addAttributes([NSAttributedStringKey.kern:kerning], range:NSMakeRange(0, self.attributedText!.length))
        self.attributedText = attribString
      }
    }
  }
  
}

