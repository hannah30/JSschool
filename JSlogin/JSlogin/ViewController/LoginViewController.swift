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
  @IBOutlet weak var LoginScrollView: UIScrollView!
  
  override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
      idInputTextField.becomeFirstResponder()
      
      NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(notification:)) , name: .UIKeyboardWillShow, object: nil)
    }
  
  @objc func keyboardWillShow(notification : Notification) {
    guard let userInfo = notification.userInfo else { return }
    guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
    LoginScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0)
  }

  @IBAction func didTabLoginBtn(_ sender: UIButton) {
    
  }
  
  @IBAction func didTabCancelBtn(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
}
