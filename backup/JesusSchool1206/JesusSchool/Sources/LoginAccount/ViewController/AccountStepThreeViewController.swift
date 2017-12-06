
import UIKit
import SwiftKeychainWrapper

class AccountStepThreeViewController: UIViewController {
  
  let segueSchoolList = "Schoollist"
  
  var accountStepData: AccountStepData!
  
  @IBOutlet weak var phoneNumberInputTextField: UITextField!
  
  lazy var alamofireRepository = AlamofireRepository.main
  
  fileprivate let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem?.title = "뒤로"
    
    phoneNumberInputTextField.becomeFirstResponder()
    keyboardTopView.delegate = self
    phoneNumberInputTextField.inputAccessoryView = keyboardTopView
  }
  
  @IBAction func didTabCancelBtn(_ sender: Any) {
    phoneNumberInputTextField.resignFirstResponder()
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension AccountStepThreeViewController{
  typealias CheckModel = (emptyMsg: String, regex: String?, regexMsg: String?)
  
  func getCheckModel(textField: UITextField) -> CheckModel? {
    switch textField {
    case phoneNumberInputTextField:
      return (
        emptyMsg: "핸드폰 번호를 입력해주세요",
        regex: "^01([0|1|6|7|8|9]{1})(\\d{3,4})(\\d{4})$",
        regexMsg: "올바른 핸드폰 번호가 아닙니다"
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

extension AccountStepThreeViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    
    guard checkField(phoneNumberInputTextField) else {return}
    
    accountStepData.phoneNumber = phoneNumberInputTextField.text!
    
    alamofireRepository.checkField(checkType: .phone, fieldValue: accountStepData.phoneNumber) {
      switch $0 {
      case .avaliable:
        self.join()
      case .exist:
        UIAlertController.alert(target: self, msg: "이미 사용중인 전화번호입니다") {
          _ in self.phoneNumberInputTextField.becomeFirstResponder()
        }
      case .empty:
        break
      }
    }
    
    
    
    /*guard let phoneNumberInputTextField = phoneNumberInputTextField.text else { return }
    if !phoneNumberInputTextField.isEmpty && phoneNumberInputTextField.characters.count > 9 {
      performSegue(withIdentifier: "Schoollist", sender: nil)
    } else {
      let alret = UIAlertController(title: "핸드폰번호 확인", message: "유효하지 않은 핸드폰 번호입니다. 다시 확인해 주세요.", preferredStyle: .alert)
      let alretAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
      alret.addAction(alretAction)
      self.present(alret, animated: true, completion: nil)
    }*/
  }
  
  func join(){
    self.alamofireRepository.join(
      id: self.accountStepData.id,
      password: self.accountStepData.password,
      nickname: self.accountStepData.nickname,
      phoneNumber: self.accountStepData.phoneNumber, responseClosure: { (joinCheckResult, id, pasword) in
        
        switch joinCheckResult {
        case .avaliable:
          
          
          self.login()
        case .exist:
          // TODO
          break
        case .empty:
          break
        }
        
    })
  }
  
  func login(){
    self.alamofireRepository.login(
      id: self.accountStepData.id,
      password: self.accountStepData.password,
      responseClosure: { loginCheckResult in
        
        switch loginCheckResult {
        case .succ:
          
          let time = Int(Date().timeIntervalSince1970)
          let loginAccount = LoginAccount(
            id: self.accountStepData.id,
            password: self.accountStepData.password,
            time: time)
          if let loginAccountData = try? JSONEncoder().encode(loginAccount) {
            KeychainWrapper.standard.set(loginAccountData, forKey: "LoginAccount")
          }
          
          self.performSegue(withIdentifier: self.segueSchoolList, sender: nil)
        case .fail:
          UIAlertController.alert(target: self, msg: "로그인에 실패하였습니다") {
            _ in self.navigationController?.dismiss(animated: true, completion: nil)
          }
        }
        
    })
  }
}

extension AccountStepThreeViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    didTabNextBtn()
    return false
  }
}
