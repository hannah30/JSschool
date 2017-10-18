//
//  MakeCountStepOneViewController.swift
//  JSlogin
//
//  Created by okkoung on 2017. 10. 17..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit

class MakeCountStepOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      let centerLineOffsetX = Double(0)
      let centerLineOffsetY = Double(view.bounds.size.height * 0.9)
      let centerLineWidth = Double(view.bounds.size.width * 1)
      let centerLineHeight = 1.0 / Double(UIScreen.main.scale)
      
      let centerLayer = CALayer()
      centerLayer.frame = CGRect(
        x: centerLineOffsetX,
        y: centerLineOffsetY,
        width: centerLineWidth,
        height: centerLineHeight
      )
      centerLayer.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.7882352941, blue: 0.4235294118, alpha: 1)
      
      view.layer.addSublayer(centerLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
