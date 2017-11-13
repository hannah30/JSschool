
import UIKit

class sayJesusSchoolViewController: UIViewController {
  
  @IBOutlet weak var sayJSTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sayJSTextView.becomeFirstResponder()
    sayJSTextView.layer.cornerRadius = 10
    sayJSTextView.layer.borderWidth = 1 / UIScreen.main.scale
    sayJSTextView.layer.borderColor = UIColor.lightGray.cgColor
    
  }

  //보내기 버튼을 클릭하면 DB로 보내야함
}
