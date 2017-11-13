import UIKit

class AccountStepOneViewController: UIViewController {
  
  
  // MARK: - property
  @IBOutlet weak var idInputTextField: UITextField!
  @IBOutlet weak var passwordInputTextField: UITextField!
  
  let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    idInputTextField.becomeFirstResponder()
    
    keyboardTopView.delegate = self
    
    idInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    passwordInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    
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
  
}
//id&password textfield check
extension AccountStepOneViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    guard let idTextFieldText = idInputTextField.text else { return }
    guard let passwordTextFieldText = passwordInputTextField.text else { return }
    if !idTextFieldText.isEmpty && idTextFieldText.characters.count > 4 &&
      !passwordTextFieldText.isEmpty && passwordTextFieldText.characters.count > 8 {
      performSegue(withIdentifier: "Nickname", sender: nil)
    } else {
      let alret = UIAlertController(title: "아이디, 패스워드 확인", message: "아이디는 5자 이상, 패스워드는 9자 이상으로 입력해 주세요.", preferredStyle: .alert)
      let alretAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
      alret.addAction(alretAction)
      self.present(alret, animated: true, completion: nil)
    }
  }
}

extension AccountStepOneViewController: UITextFieldDelegate {
  //textfield nextbtn, gobtn method
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if idInputTextField.isFirstResponder {
      passwordInputTextField.becomeFirstResponder()
    }else if passwordInputTextField.isFirstResponder {
      performSegue(withIdentifier: "Nickname", sender: nil)
    }
    return true
  }
  //idinputtextfield only letters&numbers
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == idInputTextField {
      let allowCharacters = CharacterSet.alphanumerics
      let characterSet = CharacterSet(charactersIn: string)
      return allowCharacters.isSuperset(of: characterSet)
    } else {
       return true
    }
  }
}
