import UIKit
import SafariServices

class LoginViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate {
  
  @IBOutlet weak var policyTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let termsUrl = URL(string: "https://jesuskids.cafe24.com/jesschool/terms.html")!
    let policyUrl = URL(string: "http://www.jesschool.com/jesschool/provision.html")!
    let string = "회원가입을 진행하시면 지저스스쿨의 \"이용약관\" \"개인정보 보호정책\"에 동의하시는 것입니다."
    
    let attributedString = NSMutableAttributedString(string: string)
    attributedString.addAttribute(.link, value: termsUrl,
                                  range: NSRange(location: 20, length: 5))
    attributedString.addAttribute(.link, value: policyUrl,
                                  range: NSRange(location: 27, length: 10))
    attributedString.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.white,
                                  range: NSRange(location: 0, length: attributedString.length))
    policyTextView.linkTextAttributes = [
      NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
      NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue,
    ]
    policyTextView.attributedText = attributedString
  }
  
  func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    
    let safari = SFSafariViewController(url: URL)
    safari.delegate = self
    present(safari, animated: true, completion: nil)
    return false
  }
  
}


