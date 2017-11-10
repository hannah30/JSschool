//키보드가 보일때 디폴트로 상단에 악세사리뷰에 "다음"버튼을 가지고 있게 함
import UIKit

class KeyboardAccessaryView: UIView {

  var delegate: KeyboardAccessaryViewDelegate?
//  var nextClosure: (() -> Void)?
  let keyboardViewBtn = UIButton(type: .system)
  
  
  //코드로 만들때 사용
  override init(frame: CGRect) {
    super.init(frame: frame)
    
// 미리 뷰사이즈를 가지고 있는건 안좋은 것임. 이 뷰를 사용할 해당 뷰컨트롤러에서 사이즈를 결정하게 하는게 좋음
// 뷰가 뷰사이즈를 가지고 있는건 안좋음.
//    self.frame = CGRect(x: 0, y: 0, width: 0, height: 54)

    keyboardViewBtn.setTitle("다음", for: .normal)
    keyboardViewBtn.backgroundColor = #colorLiteral(red: 1, green: 0.9019607843, blue: 0.3294117647, alpha: 1)
    keyboardViewBtn.setTitleColor(#colorLiteral(red: 0.462745098, green: 0.4666666667, blue: 0.4745098039, alpha: 1), for: .normal)
    keyboardViewBtn.layer.cornerRadius = 22
    keyboardViewBtn.layer.borderColor = #colorLiteral(red: 0.8941176471, green: 0.6666666667, blue: 0.2, alpha: 1)
    keyboardViewBtn.layer.borderWidth = 1 / UIScreen.main.scale
    keyboardViewBtn.addTarget(self, action: #selector(didTapKeyboardViewBtn(_:)), for: .touchUpInside)
    self.addSubview(keyboardViewBtn)
  }
 
//만약   viewdidload에 인스턴스를 먼저 생성하고 frame사이즈를 나중에 정한다면 미쳐 버튼이 생성이 안된다
//  그러니 슈퍼뷰의 모든 layout을 한번 불러오게 한후 다시 버튼 사이즈를 정해줘야 한다.
//  인스턴스 생성시 바로 frame을 잡아주게되면 이건 필요없음
  override func layoutSubviews() {
    super.layoutSubviews()
    keyboardViewBtn.frame = CGRect(x: self.frame.size.width - 110, y: 5, width: 100, height: 44)
  }

  //스토리보드로 호출할때 사용
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @objc func didTapKeyboardViewBtn(_ sender: UIButton) {
    // delegate
    delegate?.didTabNextBtn()
    
    // clousure
//    nextClosure?()
  }
}
//delegate
protocol KeyboardAccessaryViewDelegate {
  func didTabNextBtn()
}

