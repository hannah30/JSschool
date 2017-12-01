
import UIKit
import WebKit

class InviteFriendsViewController: UIViewController, WKUIDelegate {

  @IBOutlet weak var inviteFriendsWeb: WKWebView!
  
  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    inviteFriendsWeb = WKWebView(frame: .zero, configuration: webConfiguration)
    inviteFriendsWeb.uiDelegate = self
    view = inviteFriendsWeb
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()

    let myURL = URL(string: "https://jesuskids.cafe24.com/m/page/jesus_invite.html#")
    let myRequest = URLRequest(url: myURL!)
    inviteFriendsWeb.load(myRequest)
    
    }

  

}
