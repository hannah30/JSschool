//
//  UnderLine.swift
//  JSlogin
//
//  Created by okkoung on 2017. 10. 17..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit

class UnderLine: UIView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 1 / UIScreen.main.scale
    
  }


}
