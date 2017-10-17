//
//  ViewController.swift
//  JSlogin
//
//  Created by okkoung on 2017. 10. 12..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var loginView: LoginRoundView!
  
  @IBOutlet weak var idInputTextfield: UITextField!
  
  @IBOutlet weak var pwInputTextfield: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    

  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    
    //로그인영역 가운데 선을 보더값과 같은 값의 선으로 그리기 위해 layer를 사용
    let centerLineOffsetX = Double(0)
    let centerLineOffsetY = Double(loginView.bounds.size.height / 2.0)
    let centerLineWidth = Double(loginView.bounds.size.width * 1)
    let centerLineHeight = 1.0 / Double(UIScreen.main.scale)
    
    let centerLayer = CALayer()
    centerLayer.frame = CGRect(
      x: centerLineOffsetX,
      y: centerLineOffsetY,
      width: centerLineWidth,
      height: centerLineHeight
    )
    centerLayer.backgroundColor = UIColor.lightGray.cgColor
    
    loginView.layer.addSublayer(centerLayer)
  }

  @IBAction func loginBtn(_ sender: UIButton) {
    
  }
  @IBAction func findIdBtn(_ sender: UIButton) {
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
// UI의 어느 부분을 클릭해도 키보드가 내려가게 함
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
//키보드에 있는 return 키를 눌렀을때 키보드가 내려가게 함
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

