import UIKit
import SafariServices

class LoginViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate {
  
  @IBOutlet weak var policyTextView: UITextView!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let termsUrl = URL(string: "http://www.jesschool.com/jesschool/app_terms.html")!
    let policyUrl = URL(string: "http://www.jesschool.com/jesschool/provision.html")!
//    guard let string = policyTextView.text else { return }
    let string = "회원가입을 진행하시면 지저스스쿨의 \"이용약관\" \"개인정보 보호정책\"에 동의하시는 것입니다."
    let attributedString = NSMutableAttributedString(string: string)

    attributedString.addAttribute(.link, value: termsUrl, range: NSRange(location: 20, length: 5))
    attributedString.addAttribute(.link, value: policyUrl, range: NSRange(location: 27, length: 10))
    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length))
//    attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 19, length: 7))
//    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 19, length: 7))
//    attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.white,
//                                    NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle],
//                                   range: NSRange(location: 19, length: 7))
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
  
  @IBAction func didTapTermBtn(_ sender: Any) {
    let term = NSURL(string: "http://www.jesschool.com/jesschool/app_terms.html")!
    let termSapari = SFSafariViewController(url: term as URL)
    present(termSapari, animated: true, completion: nil)
  }
  
  @IBAction func didTapProvisionBtn(_ sender: Any) {
    let provision = NSURL(string: "http://www.jesschool.com/jesschool/provision.html")!
    let provisionSapari = SFSafariViewController(url: provision as URL)
    present(provisionSapari, animated: true, completion: nil)
  }
  
}


