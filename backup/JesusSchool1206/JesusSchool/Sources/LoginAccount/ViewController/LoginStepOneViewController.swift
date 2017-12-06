import UIKit
import SwiftKeychainWrapper

class LoginStepOneViewController: UIViewController, UITextFieldDelegate {
  
  // MARK: - property
  @IBOutlet weak var idInputTextField: UITextField!
  @IBOutlet weak var passwordInputTextField: UITextField!
  
  fileprivate let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  lazy var alamofireRepository = AlamofireRepository.main
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    idInputTextField.becomeFirstResponder()
    keyboardTopView.delegate = self
    
    // 아이디텍스트필드 편집이 끝나면 패스워드텍스트필드가 firstresponder가 되도록 적용
    idInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    passwordInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    
    /* in case of closure 
        keyboardTopView.nextClosure = {
          self.performSegue(withIdentifier: "kakunin", sender: nil)
        }
     */
    idInputTextField.inputAccessoryView = keyboardTopView
    passwordInputTextField.inputAccessoryView = keyboardTopView
  }
  
  // 아이디텍스트필드 편집이 끝나면 패스워드텍스트필드가 firstresponder가 되도록 하는 함수
  @objc func didTabExit(_ sender: UITextField) {
    if idInputTextField.isFirstResponder {
      passwordInputTextField.becomeFirstResponder()
    }else if passwordInputTextField.isFirstResponder {
      passwordInputTextField.becomeFirstResponder()
    }
  }
  
  //  로그인 취소 버튼
  @IBAction func didTabCancelBtn(_ sender: Any) {
    idInputTextField.resignFirstResponder()
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
//키보드에 있는 nextbtn, gobtn을 클릭해도 입력된 값이 app id, password정책에 맞는지 체크
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if idInputTextField.isFirstResponder, checkField(idInputTextField) {
      passwordInputTextField.becomeFirstResponder()
    } else if passwordInputTextField.isFirstResponder, checkField(passwordInputTextField) {
      performSegue(withIdentifier: "kakunin", sender: nil)
    }
    return false
  }
}

//"다음"버튼을 클릭했을때 서버 db 체크
extension LoginStepOneViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    
    guard checkField(idInputTextField) else {return}
    guard checkField(passwordInputTextField) else {return}
    
    let id = idInputTextField.text!
    let password = passwordInputTextField.text!
    
    alamofireRepository.login(
      id: id,
      password: password) {
      loginCheckResult in
        switch loginCheckResult {
        case .succ:
          
          let time = Int(Date().timeIntervalSince1970)
          let loginAccount = LoginAccount(id: id, password: password, time: time)
          if let loginAccountData = try? JSONEncoder().encode(loginAccount) {
            KeychainWrapper.standard.set(loginAccountData, forKey: "LoginAccount")
          }
          
          self.performSegue(withIdentifier: "kakunin", sender: nil)
        case .fail:
          UIAlertController.alert(target: self, msg: "아이디 또는 비밀번호가 잘못되었습니다")
        }
    }
  }
  
}

//textfield에 들어온 값이 app id, password정책에 맞는지 체크하는 함수
extension LoginStepOneViewController{
  typealias CheckModel = (emptyMsg: String, regex: String?, regexMsg: String?)
  
  func getCheckModel(textField: UITextField) -> CheckModel? {
    switch textField {
    case idInputTextField:
      return (
        emptyMsg: "아이디를 입력해주세요",
        regex: "(?=.*[a-z])(?=.*[0-9]).{8,16}",
        regexMsg: "아이디 또는 비밀번호가 잘못되었습니다"
      )
    case passwordInputTextField:
      return (
        emptyMsg: "비밀번호를 입력해주세요",
        regex: "(?=.*[a-zA-Z])(?=.*[0-9]).{9,16}",
        regexMsg: "아이디 또는 비밀번호가 잘못되었습니다"
      )
    default:
      return nil
    }
  }
  
  func checkField(_ textField: UITextField, alertCompleteClosure: ((UIAlertAction)->Void)? = nil) -> Bool {
    guard let checkModel = getCheckModel(textField: textField) else {return false}
    
    if textField.text == nil || textField.text!.isEmpty {
      UIAlertController.alert(target: self, msg: checkModel.emptyMsg, actionClosure: alertCompleteClosure)
      return false
    } else if let text = textField.text , let regex = checkModel.regex, !text.checkRegex(regex: regex) {
      UIAlertController.alert(target: self, msg: checkModel.regexMsg!, actionClosure: alertCompleteClosure)
      return false
    }
    return true
  }
  
}

struct LoginAccount: Codable {
  var id: String
  var password: String
  var time: Int
}








