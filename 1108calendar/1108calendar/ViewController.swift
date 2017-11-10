

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var calendar: KeiCalendar!
  @IBOutlet weak var monthLB: UILabel!
  @IBOutlet weak var yearLB: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    calendar.date = Date()
    monthLB.text = "\(calendar.month)"
    yearLB.text = "\(calendar.year)"
  }

  @IBAction func didTabPrevBtn(_ sender: UIButton) {
    calendar.updatePrevMonth()
  }
  
  
  @IBAction func didTabNextBtn(_ sender: UIButton) {
    calendar.updatePrevMonth()
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

