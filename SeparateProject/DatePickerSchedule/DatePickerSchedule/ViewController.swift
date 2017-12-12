
import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var ScheduleTableView: UITableView!
  @IBOutlet weak var currentDateLabel: UILabel!
  
  
  lazy var alamofireRepository = AlamofireRepository.main
  
  typealias DictionaryByDay = [Int : [ScheduleData]]
  var scheduledicByYearMonth : [Int : DictionaryByDay] = [:]
  
  var yearMonth = 0
  var day: Int? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\(scheduledicByYearMonth)")
    
    ScheduleTableView.register(UINib(nibName: "ScheduleHeader", bundle: nil),
                               forHeaderFooterViewReuseIdentifier: "header")
    
    let calendar = Calendar.init(identifier: .gregorian)
    let nowDate = Date()
    let year = calendar.component(.year, from: nowDate)
    let month = calendar.component(.month, from: nowDate)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월"
    let currentDateStr = formatter.string(from: nowDate)
    currentDateLabel.text = currentDateStr
    
    yearMonth = year * 100 + month
    
    alamofireRepository.schedules { scheduleDatas in
      self.loadScheduleData(scheduleDatas)
      self.ScheduleTableView.reloadData()
    }
  }
  
  func loadScheduleData(_ scheduleDatas: [ScheduleData]){
    for scheduleData in scheduleDatas {
      let dateInfo = scheduleData.scheduleDateInfo
      let yearMonth = dateInfo.year * 100 + dateInfo.month // 201711
      if self.scheduledicByYearMonth[yearMonth] == nil {
        self.scheduledicByYearMonth[yearMonth] = [:]
      }
      if self.scheduledicByYearMonth[yearMonth]![dateInfo.day] == nil {
        self.scheduledicByYearMonth[yearMonth]![dateInfo.day] = []
      }
      self.scheduledicByYearMonth[yearMonth]![dateInfo.day]!.append(scheduleData)
    }
  }

  @IBAction func didTabModifyBtn(_ sender: UIButton) {
    self.ScheduleTableView.setEditing(true, animated: true)
  }
  

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  

  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let scheduleDatas = scheduledicByYearMonth.flatMap { $1 }.map {$1}
    print(scheduleDatas)
    return scheduleDatas[section].count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScheduleTableViewCell
    if let scheduleDic = scheduledicByYearMonth[yearMonth] {
      let scheduleDatas = scheduleDic.flatMap({ (key, value) in return value })
      let datas = scheduleDatas[indexPath.row]
      //cell.scheduleIconImg.image = datas.scheduleIcon?.image
      //cell.scheduleLabel.text = datas.scheduleContent
      cell.scheduleDayLabel.text = String(datas.scheduleDateInfo.day)
      }
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return scheduledicByYearMonth.flatMap { $1 }.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ScheduleHeader
//    let headerView = Bundle.main.loadNibNamed("ScheduleHeader", owner: nil, options: [:])?.first! as! ScheduleHeader
    
    let sectionArray = scheduledicByYearMonth.flatMap {$1}.map {$1}
//    let sectionStr = String(sectionArray[section])
    headerView.label.text = "\(sectionArray[section][0].scheduleDateInfo.day)일 "
    
    return headerView
  }
  
  
//  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    let sectionArray = scheduledicByYearMonth.flatMap ({ (key, value) in return key})
//    let sectionStr = String(sectionArray[section])
//    return sectionStr
//  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
}
