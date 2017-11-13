

import UIKit
import WebKit

class FaqViewController: UIViewController, WKUIDelegate {

  
  @IBOutlet weak var faqWebView: WKWebView!
  
  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    faqWebView = WKWebView(frame: .zero, configuration: webConfiguration)
    faqWebView.uiDelegate = self
    view = faqWebView
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()

    let myURL = URL(string: "https://jesuskids.cafe24.com/m/page/help_call.html")
//    let myURL = URL(string: "https://www.apple.com")
    let myRequest = URLRequest(url: myURL!)
    faqWebView.load(myRequest)
    
    }




}
