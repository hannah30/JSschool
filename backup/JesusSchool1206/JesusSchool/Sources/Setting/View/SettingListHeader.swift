
import UIKit


protocol SettingListHeaderDelegate {
  func didTabUserProfileTitleImg()
}

class SettingListHeader: UIView {

  @IBOutlet weak var userAccountLabel: UILabel!
  @IBOutlet weak var userProfileTitleImg: UIImageView!
  
  var delegate: SettingListHeaderDelegate?

  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
 
//    userProfileTitleImg.layer.cornerRadius = userProfileTitleImg.bounds.size.width / 2
//    userProfileTitleImg.clipsToBounds = true
    
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    userProfileTitleImg.layer.cornerRadius = userProfileTitleImg.bounds.size.width / 2
    userProfileTitleImg.clipsToBounds = true
  }
  
  @IBAction func didTabUserModifyBtn(_ sender: UIButton) {
    
  }
  
  @IBAction func didTapUseImgChange(_ sender: UIButton) {
    delegate?.didTabUserProfileTitleImg()
  }
  
  
}
