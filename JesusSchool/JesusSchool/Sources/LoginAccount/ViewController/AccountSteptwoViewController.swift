import UIKit
//
class AccountStepTwoViewController: UIViewController {
  
  let segueAccountStepThree = "PhoneNumber"
  
  var accountStepData: AccountStepData!
  
  // MARK: - property
  @IBOutlet weak var nicknameInputTextField: UITextField!
  
  lazy var alamofireRepository = AlamofireRepository.main
  
  let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem?.title = "뒤로"
    
    nicknameInputTextField.becomeFirstResponder()
    keyboardTopView.delegate = self
    nicknameInputTextField.inputAccessoryView = keyboardTopView
  }
 
  @IBAction func didTabCancelBtn(_ sender: Any) {
    nicknameInputTextField.resignFirstResponder()
    self.navigationController?.popViewController(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueAccountStepThree {
      if let vc = segue.destination as? AccountStepThreeViewController {
        vc.accountStepData = accountStepData
      }
    }
  }
}

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

extension AccountStepTwoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    didTabNextBtn()
    return false
  }
}

/*class AccountStepTwoViewController: UIViewController {
  
  var accountStepData: AccountStepData!
  
  // MARK: - property
  @IBOutlet weak var nicknameInputTextField: UITextField!
  
  let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem?.title = "뒤로"
    
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
}*/

