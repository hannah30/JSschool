//일반 회원가입 버튼
import UIKit

class WhiteBtn: UIButton {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.layer.cornerRadius = 20
    self.layer.borderWidth = 1 / UIScreen.main.scale
    self.layer.borderColor = UIColor.white.cgColor
    self.titleLabel?.textColor = .white
    
    
  }
}

