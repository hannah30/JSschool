import UIKit
//
class AccountStepTwoViewController: UIViewController {
//  이동되는 ViewController의 id
  let segueAccountStepThree = "PhoneNumber"
  
  var accountStepData: AccountStepData!
  
  // MARK: - property
  @IBOutlet weak var nicknameInputTextField: UITextField!
  
  lazy var alamofireRepository = AlamofireRepository.main
  
  private let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    navigationItem.backBarButtonItem?.title = "뒤로"
//    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    nicknameInputTextField.becomeFirstResponder()
    keyboardTopView.delegate = self
    nicknameInputTextField.inputAccessoryView = keyboardTopView
  }
// TODO 캔슬버튼 연결해야함
  @IBAction func didTabCancelBtn(_ sender: Any) {
    nicknameInputTextField.resignFirstResponder()
    self.navigationController?.popViewController(animated: true)
  }
//  data 담아서 넘기기
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueAccountStepThree {
      if let vc = segue.destination as? AccountStepThreeViewController {
        vc.accountStepData = accountStepData
      }
    }
  }
}
//textfield에 들어온 값이 app 닉네임정책에 맞는지 체크
extension AccountStepTwoViewController{
  typealias CheckModel = (emptyMsg: String, regex: String?, regexMsg: String?)
  
  func getCheckModel(textField: UITextField) -> CheckModel? {
    switch textField {
    case nicknameInputTextField:
      return (
        emptyMsg: "닉네임을 입력해주세요",
        regex: "[A-Za-z0-9가-힣]{3,16}",
        regexMsg: "닉네임은 영대소문자, 숫자, 한글 조합 3자이상입니다"
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
//"다음"버튼을 클릭했을때 실제로 서버 db 체크
extension AccountStepTwoViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    
    guard checkField(nicknameInputTextField) else {return}
    
    accountStepData.nickname = nicknameInputTextField.text!
    
    alamofireRepository.checkField(checkType: .nick, fieldValue: accountStepData.nickname) {
      switch $0 {
      case .avaliable:
        self.performSegue(withIdentifier: self.segueAccountStepThree, sender: nil)
      case .exist:
        UIAlertController.alert(target: self, msg: "이미 사용중인 닉네임 입니다") {
          _ in self.nicknameInputTextField.becomeFirstResponder()
        }
      case .empty:
        break
      }
    }
    
  }
}
//    키보드에 있는  gobtn 터치시 서버 db 체크
extension AccountStepTwoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    didTabNextBtn()
    return false
  }
}






