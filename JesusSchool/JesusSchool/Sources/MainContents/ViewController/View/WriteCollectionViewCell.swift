

import UIKit

class WriteCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var scheduleIconImgView: UIImageView!
  @IBOutlet weak var selectedIconView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectedIconView.layer.cornerRadius = 5
    selectedIconView.isHidden = true
  }
}
