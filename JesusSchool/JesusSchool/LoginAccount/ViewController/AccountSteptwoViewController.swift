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
//    self.dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)
  }
  //텍스트필드에 관한 메서드
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      performSegue(withIdentifier: "Grade", sender: nil)
    return true
  }
}

extension AccountStepTwoViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    guard let nicknameTextFieldText = nicknameInputTextField.text else { return }
    if !nicknameTextFieldText.isEmpty && nicknameTextFieldText.characters.count >= 5 {
      performSegue(withIdentifier: "Grade", sender: nil)
    } else {
      let alret = UIAlertController(title: "닉네임 확인", message: "닉네임은 5자 이상으로 입력해 주세요.", preferredStyle: .alert)
      let alretAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
      alret.addAction(alretAction)
      self.present(alret, animated: true, completion: nil)
    }
  }
  
}


