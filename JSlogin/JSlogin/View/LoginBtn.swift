//
//  LoginBtn.swift
//  JSlogin
//
//  Created by okkoung on 2017. 10. 12..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit

class LoginBtn: UIButton {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  
  self.layer.cornerRadius = 10
  self.layer.borderWidth = 1 / UIScreen.main.scale
  self.layer.borderColor = #colorLiteral(red: 0.7926988006, green: 0.6005801558, blue: 0.1759189367, alpha: 1)
  
  }
}
