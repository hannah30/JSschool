import UIKit

class AccountStepOneViewController: UIViewController {
  
  
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
    
    //    keyboardTopView.nextClosure = {
    //      self.performSegue(withIdentifier: "kakunin", sender: nil)
    //    }
    idInputTextField.inputAccessoryView = keyboardTopView
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
  //텍스트필드에 관한 메서드
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension AccountStepOneViewController: KeyboardAccessaryViewDelegate {
  
  func didTabNextBtn() {
    guard let idTextFieldText = idInputTextField.text else { return }
    guard let passwordTextFieldText = passwordInputTextField.text else { return }
    if !idTextFieldText.isEmpty && idTextFieldText.characters.count >= 5 &&
       !passwordTextFieldText.isEmpty && passwordTextFieldText.characters.count >= 8 {
       performSegue(withIdentifier: "Nickname", sender: nil)
    } else {
      let alret = UIAlertController(title: "아이디와 패스워드를 확인해 주세요", message: "아이디는 5자 이상, 패스워드는 8자 이상으로 입력해 주세요.", preferredStyle: .alert)
      let alretAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
      alret.addAction(alretAction)
      self.present(alret, animated: true, completion: nil)
    }
  }
  
}
