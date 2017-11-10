import UIKit

class AccountSteptwoViewController: UIViewController {

  
  // MARK: - property
  @IBOutlet weak var nickNameInputTextField: UITextField!
  
  let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nickNameInputTextField.becomeFirstResponder()
    keyboardTopView.delegate = self
    
    //    keyboardTopView.nextClosure = {
    //      self.performSegue(withIdentifier: "kakunin", sender: nil)
    //    }
    nickNameInputTextField.inputAccessoryView = keyboardTopView
    
  }
// 아이디텍스트필드 편집이 끝나면 패스워드텍스트필드가 firstresponder가 되도록

  @IBAction func didTabCancelBtn(_ sender: Any) {
    nickNameInputTextField.resignFirstResponder()
    navigationController?.dismiss(animated: true, completion: nil)
  }

}

extension AccountSteptwoViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    guard let nickNameTextFieldText = nickNameInputTextField.text else { return }
    if !nickNameTextFieldText.isEmpty && nickNameTextFieldText.characters.count >= 5 {
      performSegue(withIdentifier: "Nickname", sender: nil)
    }else {
      let alret = UIAlertController(title: "닉네임을 확인해 주세요", message: "닉네임은 5자 이상으로 입력해 주세요.", preferredStyle: .alert)
      let alretAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
      alret.addAction(alretAction)
    }
  }  
}
