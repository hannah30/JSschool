import UIKit
import Alamofire

class AccountStepOneViewController: UIViewController {
  //  이동되는 ViewController의 id
  private let segueAccountStepTwo = "Nickname"
  
  // MARK: - property
  @IBOutlet weak var idInputTextField: UITextField!
  @IBOutlet weak var passwordInputTextField: UITextField!
  
  //  data instance
  lazy var accountStepData = AccountStepData()
  lazy var alamofireRepository = AlamofireRepository.main
  
  private let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    idInputTextField.becomeFirstResponder()
    keyboardTopView.delegate = self
    
    // 아이디텍스트필드 편집이 끝나면 패스워드텍스트필드가 firstresponder가 되도록 적용
    idInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    passwordInputTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    
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
  
  //회원가입 취소버튼
  @IBAction func didTabCancelBtn(_ sender: Any) {
    idInputTextField.resignFirstResponder()
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueAccountStepTwo {
      if let vc = segue.destination as? AccountStepTwoViewController {
        vc.accountStepData = accountStepData
      }
    }
  }
}

extension AccountStepOneViewController{
  typealias CheckModel = (emptyMsg: String, regex: String?, regexMsg: String?)
  
  //textfield에 들어온 값이 app id, password정책에 맞는지 체크하는 함수
  func getCheckModel(textField: UITextField) -> CheckModel? {
    switch textField {
    case idInputTextField:
      return (
        emptyMsg: "아이디를 입력해주세요",
        regex: "([a-z0-9]).{8,16}",
        regexMsg: "아이디는 영소문자,숫자 8자이상입니다"
      )
    case passwordInputTextField:
      return (
        emptyMsg: "비밀번호를 입력해주세요",
        regex: "(?=.*[a-zA-Z])(?=.*[0-9]).{9,16}",
        regexMsg: "비밀번호는 영문,숫자 조합 9자이상입니다(특수문자가능)"
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
extension AccountStepOneViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    guard checkField(idInputTextField) else {return}
    guard checkField(passwordInputTextField) else {return}
    
    accountStepData.id = idInputTextField.text!
    accountStepData.password = passwordInputTextField.text!
    
    alamofireRepository.checkField(checkType: .id, fieldValue: accountStepData.id) {
      switch $0 {
      case .avaliable:
        self.performSegue(withIdentifier: self.segueAccountStepTwo, sender: nil)
      case .exist:
        UIAlertController.alert(target: self, msg: "이미 사용중인 아이디 입니다") {
          _ in self.idInputTextField.becomeFirstResponder()
        }
      case .empty:
        break
      }
    }
  }
}

//키보드에 있는 nextbtn, gobtn을 클릭해도 입력된 값이 app id, password정책에 맞는지 체크
extension AccountStepOneViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if idInputTextField.isFirstResponder, checkField(idInputTextField) {
      passwordInputTextField.becomeFirstResponder()
    } else if passwordInputTextField.isFirstResponder, checkField(passwordInputTextField) {
      didTabNextBtn()
    }
    return false
  }
}

