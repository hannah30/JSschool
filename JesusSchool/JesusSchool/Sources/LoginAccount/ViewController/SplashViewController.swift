
import UIKit
import SwiftKeychainWrapper


class SplashViewController: UIViewController {
  
  lazy var alamofireRepository = AlamofireRepository.main
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if  let loginAccountData = KeychainWrapper.standard.data(forKey: "LoginAccount"),
      let loginAccount = try? JSONDecoder().decode(LoginAccount.self, from: loginAccountData) {

      let now = Int(Date().timeIntervalSince1970)
      if loginAccount.time >= now - (60 * 60 * 24 * 30) {
        alamofireRepository.login(id: loginAccount.id, password: loginAccount.password, responseClosure: {
          loginCheckResult in
          switch loginCheckResult {
          case .succ:

            var loginAccount = loginAccount
            loginAccount.time = Int(Date().timeIntervalSince1970)

            if let loginAccountData = try? JSONEncoder().encode(loginAccount) {
              KeychainWrapper.standard.set(loginAccountData, forKey: "LoginAccount")
            }

            self.performSegue(withIdentifier: "GoToMain", sender: nil)
            break
          case .fail:
            KeychainWrapper.standard.removeObject(forKey: "LoginAccount")
            self.performSegue(withIdentifier: "GotoAccountCheck", sender: nil)
          }
        })
      } else {
        KeychainWrapper.standard.removeObject(forKey: "LoginAccount")
      }
    }
  }

}

