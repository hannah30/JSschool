
import UIKit
import WebKit

class SupervisorViewController: UIViewController, WKUIDelegate {

  @IBOutlet weak var supervisorWeb: WKWebView!
  
  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    supervisorWeb = WKWebView(frame: .zero, configuration: webConfiguration)
    supervisorWeb.uiDelegate = self
    view = supervisorWeb
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()

    let myURL = URL(string: "https://jesuskids.cafe24.com/m/page/school_option.html")
    let myRequest = URLRequest(url: myURL!)
    supervisorWeb.load(myRequest)
    
    }


}
