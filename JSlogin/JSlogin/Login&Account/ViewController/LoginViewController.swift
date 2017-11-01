//
//  MakeCountStepOneViewController.swift
//  JSlogin
//
//  Created by okkoung on 2017. 10. 17..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var passwordInputTextField: UITextField!
  @IBOutlet weak var idInputTextField: UITextField!
 
 
  
 
  override func viewDidLoad() {
        super.viewDidLoad()
    
    idInputTextField.becomeFirstResponder()
    
    let keyboardView = UIView()
    keyboardView.frame = CGRect(x: 0, y: 0, width: 0, height: 54)
    
    let keyboardViewBtn = UIButton(type: .custom)
    let widthKeyboard = view.bounds.size.width
    keyboardViewBtn.frame = CGRect(x: widthKeyboard - 110, y: 5, width: 100, height: 44)
    keyboardViewBtn.setTitle("다음", for: .normal)
    keyboardViewBtn.backgroundColor = #colorLiteral(red: 1, green: 0.9019607843, blue: 0.3294117647, alpha: 1)
    keyboardViewBtn.setTitleColor(#colorLiteral(red: 0.462745098, green: 0.4666666667, blue: 0.4745098039, alpha: 1), for: .normal)
    keyboardViewBtn.layer.cornerRadius = 22
    keyboardViewBtn.layer.borderColor = #colorLiteral(red: 0.8941176471, green: 0.6666666667, blue: 0.2, alpha: 1)
    keyboardViewBtn.layer.borderWidth = 1 / UIScreen.main.scale
    keyboardView.addSubview(keyboardViewBtn)
    
    idInputTextField.inputAccessoryView = keyboardView
    
    
    }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    
   
  }

 
  
  @IBAction func didTabCancelBtn(_ sender: Any) {
    idInputTextField.resignFirstResponder()
    navigationController?.dismiss(animated: true, completion: nil)
    
    
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }





}
