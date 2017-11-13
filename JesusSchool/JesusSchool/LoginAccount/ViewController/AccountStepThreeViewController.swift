
import UIKit

class AccountStepThreeViewController: UIViewController {

  @IBOutlet weak var phoneNumberInputTextField: UITextField!
  
    fileprivate let keyboardTopView: KeyboardAccessaryView = KeyboardAccessaryView(frame: CGRect(x: 0, y: 0, width: 0, height: 54))
  
    override func viewDidLoad() {
        super.viewDidLoad()

      phoneNumberInputTextField.becomeFirstResponder()
      keyboardTopView.delegate = self
      phoneNumberInputTextField.inputAccessoryView = keyboardTopView
    }

  @IBAction func didTabCancelBtn(_ sender: Any) {
    phoneNumberInputTextField.resignFirstResponder()
    self.navigationController?.popViewController(animated: true)
  }

}

extension AccountStepThreeViewController: KeyboardAccessaryViewDelegate {
  func didTabNextBtn() {
    guard let phoneNumberInputTextField = phoneNumberInputTextField.text else { return }
    if !phoneNumberInputTextField.isEmpty && phoneNumberInputTextField.characters.count > 9 {
      performSegue(withIdentifier: "Level", sender: nil)
    } else {
      let alret = UIAlertController(title: "핸드폰번호 확인", message: "유효하지 않은 핸드폰 번호입니다. 다시 확인해 주세요.", preferredStyle: .alert)
      let alretAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
      alret.addAction(alretAction)
      self.present(alret, animated: true, completion: nil)
    }
  }
}

