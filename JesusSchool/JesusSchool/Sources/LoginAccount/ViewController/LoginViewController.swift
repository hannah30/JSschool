import UIKit
import SafariServices

class LoginViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate {
  
  @IBOutlet weak var policyTextView: UITextView!
  @IBOutlet weak var cacaoLoginBtn: YellowBtn!
  
  lazy var alamofireRepository = AlamofireRepository.main
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    카카오로그인 버튼에 카카오ci 추가
    let cacaoImg: UIImageView = {
      let cacaoimg = UIImageView()
      cacaoimg.image = UIImage(named: "cacaobtn")
      cacaoimg.contentMode = .scaleAspectFit
      return cacaoimg
    }()
    
    cacaoImg.translatesAutoresizingMaskIntoConstraints = false
    cacaoLoginBtn.addSubview(cacaoImg)
    cacaoImg.widthAnchor.constraint(equalToConstant: 28).isActive = true
    cacaoImg.heightAnchor.constraint(equalToConstant: 28).isActive = true
    cacaoImg.leftAnchor.constraint(equalTo: cacaoLoginBtn.leftAnchor, constant: 45).isActive = true
    cacaoImg.centerYAnchor.constraint(equalTo: cacaoLoginBtn.centerYAnchor).isActive = true
    
    //    이용약관 및 개인정보보호정책 텍스트를 사파리뷰로 띄워줌
    let termsUrl = URL(string: "https://jesuskids.cafe24.com/jesschool/terms.html")!
    let policyUrl = URL(string: "http://www.jesschool.com/jesschool/provision.html")!
    let string = "회원가입을 진행하시면 지저스스쿨의 \"이용약관\" \"개인정보 보호정책\"에 동의하시는 것입니다."
    
    //    약관에 들어가는 text 컬러(white), underline, link 추가
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
    //    회원약관 및 개인정보보호정책이 확정되고 하기
    //    policyTextView.attributedText = attributedString
    
  }
  //  bg가 있어서 네비게이션바 hidden시킴
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  //  실제 사파리뷰로 띄울 텍스트를 touch했을때 실행되는 method
  @available(iOS 10.0, *)
  @available(iOS 10.0, *)
  func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    
    let safari = SFSafariViewController(url: URL)
    safari.delegate = self
    present(safari, animated: true, completion: nil)
    return false
  }
  
}


