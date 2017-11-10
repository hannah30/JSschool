import UIKit

class LoginStepOneViewController: UIViewController, UITextFieldDelegate {
  
  // MARK: - property
  @IBOutlet weak var idInputTextField: UITextField!
  @IBOutlet weak var passwordInputTextField: UITextField!
  
  fileprivate let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    idInputTextField.becomeFirstResponder()
    
    keyboardTopView.delegate = self
    
    idInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    passwordInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    
    // closure
    //    keyboardTopView.nextClosure = {
    //      self.performSegue(withIdentifier: "kakunin", sender: nil)
    //    }
    idInputTextField.inputAccessoryView = keyboardTopView
    passwordInputTextField.inputAccessoryView = keyboardTopView
  }
  
  // 아이디텍스트필드 편집이 끝나면 패스워드텍스트필드가 firstresponder가 되도록
  @objc func didTabExit(_ sender: UITextField) {
    if idInputTextField.isFirstResponder {
      passwordInputTextField.becomeFirstResponder()
    }else if passwordInputTextField.isFirstResponder {
      passwordInputTextField.becomeFirstResponder()
    }
  }
  @IBAction func didTabCancelBtn(_ sender: Any) {
    idInputTextField.resignFirstResponder()
    navigationController?.dismiss(animated: true, completion: nil)
  }
  //키보드의 next, go버튼
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if idInputTextField.isFirstResponder {
      passwordInputTextField.becomeFirstResponder()
    }else if passwordInputTextField.isFirstResponder {
      performSegue(withIdentifier: "kakunin", sender: nil)
    }
    return true
  }
}

extension LoginStepOneViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    //입력된 아이디와 패스워드값을 가져와서 서버에 저장된 값과 일치하는지 확인할 코드가 들어가야함
    performSegue(withIdentifier: "kakunin", sender: nil)
  }
  
}








