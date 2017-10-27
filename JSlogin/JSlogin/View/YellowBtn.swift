

import UIKit

class YellowBtn: UIButton {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  
  self.layer.cornerRadius = 20
  self.layer.borderWidth = 1 / UIScreen.main.scale
    self.layer.borderColor = #colorLiteral(red: 0.8941176471, green: 0.6666666667, blue: 0.2, alpha: 1)
  self.backgroundColor = #colorLiteral(red: 1, green: 0.9019607843, blue: 0.3294117647, alpha: 1)
  self.titleLabel?.textColor = #colorLiteral(red: 0.3882352941, green: 0.3921568627, blue: 0.4, alpha: 1)
  }
}
