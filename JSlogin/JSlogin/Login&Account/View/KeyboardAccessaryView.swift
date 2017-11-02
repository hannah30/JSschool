

import UIKit

class KeyboardAccessaryView: UIView {

  var delegate: KeyboardAccessaryViewDelegate?
  var keyboardViewBtn: UIButton = UIButton(type: .custom)
  
  
  //코드로 만들때 사용
  override init(frame: CGRect) {
    super.init(frame: frame)
    
// 미리 뷰사이즈를 가지고 있는건 안좋은 것임. 이 뷰를 사용할 해당 뷰컨트롤러에서 사이즈를 결정하게 하는게 좋음
// 뷰가 뷰사이즈를 가지고 있는건 안좋음.
//    self.frame = CGRect(x: 0, y: 0, width: 0, height: 54)
    
//    let keyboardViewBtn = UIButton(type: .custom)
    let widthKeyboard = self.frame.size.width
    keyboardViewBtn.frame = CGRect(x: widthKeyboard - 110, y: 5, width: 100, height: 44)
    keyboardViewBtn.setTitle("다음", for: .normal)
    keyboardViewBtn.backgroundColor = #colorLiteral(red: 1, green: 0.9019607843, blue: 0.3294117647, alpha: 1)
    keyboardViewBtn.setTitleColor(#colorLiteral(red: 0.462745098, green: 0.4666666667, blue: 0.4745098039, alpha: 1), for: .normal)
    keyboardViewBtn.layer.cornerRadius = 22
    keyboardViewBtn.layer.borderColor = #colorLiteral(red: 0.8941176471, green: 0.6666666667, blue: 0.2, alpha: 1)
    keyboardViewBtn.layer.borderWidth = 1 / UIScreen.main.scale
    keyboardViewBtn.addTarget(self, action: #selector(didTapKeyboardViewBtn(_:)), for: .touchUpInside)
    self.addSubview(keyboardViewBtn)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    keyboardViewBtn.frame = CGRect(x: self.frame.size.width - 110, y: 5, width: 100, height: 44)
  }

  //스토리보드로 호출할때 사용
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    
    
  }
  
  @objc func didTapKeyboardViewBtn(_ sender: UIButton) {
    delegate?.didTabNextBtn()
  }
  
}

protocol KeyboardAccessaryViewDelegate {
  func didTabNextBtn()
}

