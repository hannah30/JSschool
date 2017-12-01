
import UIKit

class ListTableViewCell: UITableViewCell {

  @IBOutlet weak var settingListImgView: UIImageView!
  @IBOutlet weak var settingListCellTitle: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
