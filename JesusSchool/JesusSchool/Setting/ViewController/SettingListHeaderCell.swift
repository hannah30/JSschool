

import UIKit

protocol SettingListHeaderCellDelegate {
  func didTabUserProfileTitleImg()
}
class SettingListHeaderCell: UITableViewCell {

  @IBOutlet weak var userAccountLabel: UILabel!
  @IBOutlet weak var userProfileModifyLabel: UILabel!
  @IBOutlet weak var userProfileTitleImg: UIImageView!
  
  var delegate: SettingListHeaderCellDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      userProfileTitleImg.layer.cornerRadius = userProfileTitleImg.bounds.size.width / 2
      userProfileTitleImg.clipsToBounds = true
      
     
      
    }

  @IBAction func didTabUserProfileImgChange(_ sender: UIButton) {
    delegate?.didTabUserProfileTitleImg()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
