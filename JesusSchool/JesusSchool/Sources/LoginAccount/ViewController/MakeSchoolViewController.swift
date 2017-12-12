

import UIKit

class MakeSchoolViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var introductionTextView: UITextView!
  @IBOutlet weak var approveRegistImgView: UIImageView!
  @IBOutlet weak var allRegistImgView: UIImageView!
  @IBOutlet weak var approveRegistBtn: UIButton!
  @IBOutlet weak var allRegistBtn: UIButton!
  
  @IBOutlet weak var ChurchNameTextField: UITextField!
  @IBOutlet weak var departmentNameTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    introductionTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    introductionTextView.layer.borderWidth = 1 / UIScreen.main.scale
    introductionTextView.layer.cornerRadius = 5
    
    // 교회이름텍스트필드 편집이 끝나면 부서이름텍스트필드가 firstresponder가 되도록 적용
    ChurchNameTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    departmentNameTextField.addTarget(self, action: #selector(didTabExit(_:)), for: .editingDidEndOnExit)
    
  }
  
  //  텍스트뷰에 입력가능한 글자수 300으로한제한
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    return textView.text.count + (text.count - range.length) <= 300
  }
  
  // 교회이름텍스트필드 편집이 끝나면 부서이름텍스트필드, 교회소개텍스트뷰가 firstresponder가 되도록 적용
  @objc func didTabExit(_ sender: UITextField) {
    if ChurchNameTextField.isFirstResponder {
      departmentNameTextField.becomeFirstResponder()
    }else if departmentNameTextField.isFirstResponder {
      introductionTextView.becomeFirstResponder()
    }
  }
  
  //키보드에 있는 nextbtn을 터치하면 입력된 값이 app 정책에 맞는지 체크
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if ChurchNameTextField.isFirstResponder/*, checkField(idInputTextField)*/ {
      departmentNameTextField.becomeFirstResponder()
    } else if departmentNameTextField.isFirstResponder/*, checkField(passwordInputTextField) */{
      introductionTextView.becomeFirstResponder()
    }
    return false
  }
  
  
  @IBAction func didTabApproveRegistBtn(_ sender: UIButton) {
    
    switch sender.tag {
    case 0:
      approveRegistBtn.isSelected = !approveRegistBtn.isSelected
      if approveRegistBtn.isSelected {
        approveRegistImgView.image = UIImage(named: "checked")
        allRegistBtn.isSelected = false
        allRegistImgView.image = UIImage(named: "unchecked")
      }else {
        approveRegistImgView.image = UIImage(named: "unchecked")
        allRegistBtn.isSelected = true
        allRegistImgView.image = UIImage(named: "checked")
      }
    case 1:
      allRegistBtn.isSelected = !allRegistBtn.isSelected
      if allRegistBtn.isSelected {
        allRegistImgView.image = UIImage(named: "checked")
        approveRegistBtn.isSelected = false
        approveRegistImgView.image = UIImage(named: "unchecked")
      }else {
        allRegistImgView.image = UIImage(named: "unchecked")
        approveRegistBtn.isSelected = true
        approveRegistImgView.image = UIImage(named: "checked")
      }
    default:
      print("no sender")
    }
    
  }
  
  @IBAction func didTabMakeChurchBtn(_ sender: UIButton) {
    
  }
  
  
}


