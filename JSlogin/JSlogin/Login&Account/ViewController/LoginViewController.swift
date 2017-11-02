

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
  
// MARK: - property
  @IBOutlet weak var passwordInputTextField: UITextField!
  @IBOutlet weak var idInputTextField: UITextField!
 
 let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
 
  override func viewDidLoad() {
        super.viewDidLoad()
    
    idInputTextField.becomeFirstResponder()
    
    
    keyboardTopView.delegate = self
    idInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    passwordInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    
    
    }

//  override func viewDidAppear(_ animated: Bool) {
//    idInputTextField.becomeFirstResponder()
//  }
  
  //키보드의 AccessoryView에 customView 넣기
  
  override var inputAccessoryView: UIView? {
    return keyboardTopView
  }
  


  @objc func didTabExit(_ sender: UITextField) {
    if sender === idInputTextField {
      passwordInputTextField.becomeFirstResponder()
    }
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

extension LoginViewController: KeyboardAccessaryViewDelegate {
  
  func didTabNextBtn() {
    performSegue(withIdentifier: "kakunin", sender: nil)
  }
  
}







