//
//  LoginRoundView.swift
//  JSlogin
//
//  Created by okkoung on 2017. 10. 12..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit

class LoginRoundView: UIView {

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.cornerRadius = 10
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 1 / UIScreen.main.scale
    
  }

}
