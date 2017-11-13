import UIKit

class AccountStepTwoViewController: UIViewController {
  
  
  // MARK: - property
  @IBOutlet weak var nicknameInputTextField: UITextField!
  
  let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nicknameInputTextField.becomeFirstResponder()
    keyboardTopView.delegate = self
    nicknameInputTextField.inputAccessoryView = keyboardTopView
  }
 
  @IBAction func didTabCancelBtn(_ sender: Any) {
    nicknameInputTextField.resignFirstResponder()
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension AccountStepTwoViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    guard let nicknameTextFieldText = nicknameInputTextField.text else { return }
    if !nicknameTextFieldText.isEmpty && nicknameTextFieldText.characters.count > 2 {
      performSegue(withIdentifier: "PhoneNumber", sender: nil)
    } else {
      let alret = UIAlertController(title: "닉네임 확인", message: "닉네임은 3자 이상으로 입력해 주세요.", preferredStyle: .alert)
      let alretAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
      alret.addAction(alretAction)
      self.present(alret, animated: true, completion: nil)
    }
  }
}

extension AccountStepTwoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    performSegue(withIdentifier: "PhoneNumber", sender: nil)
    return true
  }
}

