//
//  kerning.swift
//  JSlogin
//
//  Created by okkoung on 2017. 10. 18..
//  Copyright © 2017년 okkoung. All rights reserved.
//

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

