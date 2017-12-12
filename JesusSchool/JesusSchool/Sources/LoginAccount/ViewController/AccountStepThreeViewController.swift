
import UIKit
import SwiftKeychainWrapper

class AccountStepThreeViewController: UIViewController {
  //  이동되는 ViewController의 id
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
  // TODO 캔슬버튼 연결해야함
  @IBAction func didTabCancelBtn(_ sender: Any) {
    phoneNumberInputTextField.resignFirstResponder()
    self.navigationController?.popViewController(animated: true)
  }
  
}
//textfield에 들어온 값이 app 핸드폰 정책에 맞는지 체크
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
    
  }
  
  func join(){
    self.alamofireRepository.join(
      id: self.accountStepData.id,
      password: self.accountStepData.password,
      nickname: self.accountStepData.nickname,
      phoneNumber: self.accountStepData.phoneNumber, responseClosure: { (joinCheckResult, id, pasword) in
        
        switch joinCheckResult {
        case .avaliable:
          // 회원가입 만료 후 자동로긴 시키기 위해
          self.login()
        case .exist:
          // 혹시 모를 오류를 대비, 만에 하나 이 시점에 다른 회원이 먼저 회원가입을 해서 오류가 생기게 될 경우
          UIAlertController.alert(target: self, msg: "예기치 않은 오류로 회원가입에 실패하셨습니다.")
          break
        case .empty:
          break
        }
        
    })
  }
  //  회원가입이 끝나자 마자 자동 로그인 시킴
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
          //         회원가입 후 회원가입페이지는 dismiss시키고 교회학교 가입 페이지로 이동
          let loginCheckStoryboard = UIStoryboard(name: "Login", bundle: nil)
          let loginViewController = loginCheckStoryboard.instantiateViewController(withIdentifier: "SchoolListNavi")
          self.present(loginViewController, animated: true, completion: nil)
          self.dismiss(animated: true, completion: nil)
        //          self.performSegue(withIdentifier: self.segueSchoolList, sender: nil)
        case .fail:
          UIAlertController.alert(target: self, msg: "로그인에 실패하였습니다") {
            _ in self.navigationController?.dismiss(animated: true, completion: nil)
          }
        }
        
    })
  }
}
//    키보드에 있는  gobtn 터치시 서버 db 체크
extension AccountStepThreeViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    didTabNextBtn()
    return false
  }
}

