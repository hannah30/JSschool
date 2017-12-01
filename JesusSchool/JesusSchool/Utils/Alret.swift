
import UIKit

extension UIAlertController {
  
  static func alert(target: UIViewController, msg: String, actionClosure: ((UIAlertAction)->Void)? = nil){
    let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: actionClosure))
    target.present(alert, animated: true, completion: nil)
  }
  
  static func presentAlertController(target: UIViewController,
                                     title: String?,
                                     massage: String?,
                                     actionStyle: UIAlertActionStyle = UIAlertActionStyle.default,
                                     cancelBtn: Bool,
                                     completion: ((UIAlertAction)->Void)?) {
    let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: actionStyle, handler: completion)
    alert.addAction(okAction)
    if cancelBtn {
      let cancelAction = UIAlertAction(title: "취소", style: actionStyle, handler: completion)
      alert.addAction(cancelAction)
    }
    target.present(alert, animated: true, completion: nil)
  }
}
