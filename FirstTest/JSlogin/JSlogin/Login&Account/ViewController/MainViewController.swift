import UIKit
import SafariServices

class MainViewController: UIViewController, SFSafariViewControllerDelegate {
  
  @IBOutlet weak var headCopyText: KeringLabel!
  @IBOutlet weak var kakaoLoginBtn: UIButton!
  @IBOutlet weak var whiteLoginBtn: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    kakaoLoginBtn.layer.cornerRadius = 25
    kakaoLoginBtn.layer.borderWidth = 1 / UIScreen.main.scale
    kakaoLoginBtn.layer.borderColor = #colorLiteral(red: 0.8941176471, green: 0.6666666667, blue: 0.2, alpha: 1)
    kakaoLoginBtn.backgroundColor = #colorLiteral(red: 1, green: 0.9019607843, blue: 0.3294117647, alpha: 1)
    kakaoLoginBtn.titleLabel?.textColor = #colorLiteral(red: 0.3882352941, green: 0.3921568627, blue: 0.4, alpha: 1)

    whiteLoginBtn.layer.cornerRadius = 25
    whiteLoginBtn.layer.borderWidth = 1 / UIScreen.main.scale
    whiteLoginBtn.layer.borderColor = UIColor.white.cgColor
    whiteLoginBtn.titleLabel?.textColor = .white

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

