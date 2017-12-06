
import UIKit
import SwiftKeychainWrapper


class SplashViewController: UIViewController {
  
  lazy var alamofireRepository = AlamofireRepository.main
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      if  let loginAccountData = KeychainWrapper.standard.data(forKey: "LoginAccount"),
        let loginAccount = try? JSONDecoder().decode(LoginAccount.self, from: loginAccountData) {
        
        let now = Int(Date().timeIntervalSince1970)
        if loginAccount.time >= now - (60 * 60 * 24 * 30) {
          self.alamofireRepository.login(id: loginAccount.id, password: loginAccount.password, responseClosure: {
            loginCheckResult in
            switch loginCheckResult {
            case .succ:
              
              var loginAccount = loginAccount
              loginAccount.time = Int(Date().timeIntervalSince1970)
              
              if let loginAccountData = try? JSONEncoder().encode(loginAccount) {
                KeychainWrapper.standard.set(loginAccountData, forKey: "LoginAccount")
              }
              
              let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
              let mainGoViewController = mainStoryboard.instantiateViewController(withIdentifier: "ThisIsMain") as! TempViewController
              self.present(mainGoViewController, animated: true, completion: nil)
              //            self.performSegue(withIdentifier: "GoToMain", sender: nil)
              break
            case .fail:
              KeychainWrapper.standard.removeObject(forKey: "LoginAccount")
              self.performSegue(withIdentifier: "GotoAccountCheck", sender: nil)
            }
          })
        } else { // 자동로그인 정보 O but 1달이상 경과 했을 때
          KeychainWrapper.standard.removeObject(forKey: "LoginAccount")
          self.performSegue(withIdentifier: "GotoAccountCheck", sender: nil)
        }
      } else { // 자동로그인 정보 X
        self.performSegue(withIdentifier: "GotoAccountCheck", sender: nil)
      }
    }
  }
  
}

