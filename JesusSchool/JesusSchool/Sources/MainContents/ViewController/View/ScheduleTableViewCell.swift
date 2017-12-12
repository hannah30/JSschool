
import UIKit

class ScheduleTableViewCell: UITableViewCell {
  @IBOutlet weak var scheduleIconImg: UIImageView!
  @IBOutlet weak var scheduleLabel: UILabel!
  @IBOutlet weak var scheduleDayLabel: UILabel!
  
  var scheduleData: ScheduleData!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
