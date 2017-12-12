

import UIKit

class ScheduleViewController: UIViewController {
  
  @IBOutlet weak var ScheduleTableView: UITableView!
  @IBOutlet weak var currentDateLabel: UILabel!
  
  let scheduleModel = ScheduleModel()
  
  lazy var alamofireRepository = AlamofireRepository.main

    override func viewDidLoad() {
        super.viewDidLoad()
      
      ScheduleTableView.register(UINib(nibName: "ScheduleHeader", bundle: nil),
                                 forHeaderFooterViewReuseIdentifier: "header")
      
//      ScheduleTableView.rowHeight = UITableViewAutomaticDimension
//      ScheduleTableView.estimatedRowHeight = 50
      
      let nowDate = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy년 MM월 dd일"
      let currentDateStr = formatter.string(from: nowDate)
      currentDateLabel.text = "오늘 \(currentDateStr)"
      
      alamofireRepository.schedules { scheduleDatas in
        
        self.scheduleModel.appendData(scheduleDatas)
        
        self.ScheduleTableView.separatorColor = (self.scheduleModel.yearMonthCount == 0) ? .clear : .lightGray
        
        self.ScheduleTableView.reloadData()
        
      }
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let cell = sender as? ScheduleTableViewCell, let destVC = segue.destination as? WriteViewController {
        destVC.scheduleData = cell.scheduleData
    }
  }
  
  @IBAction func unwind(_ segue: UIStoryboardSegue){
    if segue.identifier == "unwindSegueWriteToSchedule" {
      // TODO
      /*scheduleModel.clear()
      alamofireRepository.schedules { scheduleDatas in
        
        self.scheduleModel.appendData(scheduleDatas)
        
        self.ScheduleTableView.reloadData()
      }*/
      self.ScheduleTableView.reloadData()
    }
  }
  
  func getIsPast(_ dateInfo: (year: Int, month: Int, day: Int)) -> Bool{
    let calendar = Calendar.current
    let date = Date()
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    
    return (dateInfo.year < year || dateInfo.month < month || dateInfo.day < day)
  }

}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    if scheduleModel.yearMonthCount == 0 {
      return 1
    } else {
      return scheduleModel.yearMonthCount
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    if scheduleModel.yearMonthCount == 0 {
      return 0
    } else {
      return 30
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if scheduleModel.yearMonthCount == 0 {
      return nil
    } else {
      let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ScheduleHeader
      
      let yearMonth = scheduleModel.yearMonthSectionKey(section: section)
      
      headerView.label.text = String(format: "%d년 %02d월", yearMonth/100, yearMonth%100)
      
      return headerView
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if scheduleModel.yearMonthCount == 0 {
      return 1
    } else {
      return scheduleModel.dayDatasCount(section: section)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if scheduleModel.yearMonthCount == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "NoScheduleCell", for: indexPath)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      
      let scheduleData = scheduleModel.dayData(section: indexPath.section, row: indexPath.row)
      
      let isPast = getIsPast(scheduleData.scheduleDateInfo)
      
      if let cell = cell as? ScheduleTableViewCell {
        cell.contentView.alpha = (isPast) ? 0.5 : 1.0
        cell.scheduleData = scheduleData
        cell.scheduleDayLabel.text = "\(scheduleData.scheduleDateInfo.day)일"
        if scheduleData.scheduleIcon?.rawValue == 0 {
          cell.scheduleIconImg.isHidden = true
        } else {
          cell.scheduleIconImg.isHidden = false
          cell.scheduleIconImg.image = scheduleData.scheduleIcon?.image
        }
        cell.scheduleLabel.text = scheduleData.scheduleContent
      }
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell{
      if !getIsPast(cell.scheduleData.scheduleDateInfo) { // cell.contentView.alpha == 1.0
        self.performSegue(withIdentifier: "segueToWrite", sender: cell)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if let cell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell{
      if getIsPast(cell.scheduleData.scheduleDateInfo) { // cell.contentView.alpha == 1.0
        return nil
      }
    }
    return indexPath
  }
  
}

class ScheduleModel{
  
  typealias DictionaryByDay = [Int : [ScheduleData]]
  var scheduledicByYearMonth : [Int : DictionaryByDay] = [:]
  
  func appendData(_ scheduleDatas: [ScheduleData]){
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
  
  func clear(){
    scheduledicByYearMonth.removeAll()
  }
  
  var yearMonthCount: Int {
    return scheduledicByYearMonth.count
  }
  
  func yearMonthSectionKey(section: Int) -> Int {
    return scheduledicByYearMonth.map({ $0.key }).sorted()[section]
  }
  
  func dayDatasCount(section: Int) -> Int {
    return scheduledicByYearMonth[yearMonthSectionKey(section: section)]!.map({$1}).reduce(0,{$0+$1.count})
  }
  
  func dayData(section: Int, row: Int) -> ScheduleData {
    return scheduledicByYearMonth[yearMonthSectionKey(section: section)]!.flatMap({$1})
      .sorted(by: { $0.scheduleDateInfo.day < $1.scheduleDateInfo.day })[row]
  }
  
}
