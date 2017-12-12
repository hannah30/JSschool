

import UIKit

class ScheduleViewController: UIViewController {
  
  @IBOutlet weak var ScheduleTableView: UITableView!
  @IBOutlet weak var currentDateLabel: UILabel!
  @IBOutlet weak var scheduleWriteBtn: UIButton!
  
  let scheduleModel = ScheduleModel()
  
  lazy var alamofireRepositorySchedule = AlamofireRepository.main
  
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
    
    alamofireRepositorySchedule.schedules { scheduleDatas in
      
      self.scheduleModel.appendData(scheduleDatas)
      
      self.ScheduleTableView.separatorColor = (self.scheduleModel.yearMonthCount == 0) ? .clear : #colorLiteral(red: 0.8901960784, green: 0.8862745098, blue: 0.8941176471, alpha: 1)
      
      self.ScheduleTableView.reloadData()
      
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let cell = sender as? ScheduleTableViewCell, let destVC = segue.destination as? WriteViewController {
      destVC.scheduleData = cell.scheduleData
    }
  }
  //write를 끝냈을때 data reload
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
  // 지난 일정인지 체크하기 위해 현재시간보다 지난시간인지 체크
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
    //   일정이 하나도 없을 때
    if scheduleModel.yearMonthCount == 0 {
      return 1
    } else {
      //      일정이 있을 때
      return scheduleModel.yearMonthCount
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    //   일정이 없을 때 headerview를 안보이게 하기 위해
    if scheduleModel.yearMonthCount == 0 {
      return 0
    } else {
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if scheduleModel.yearMonthCount == 0 {
      return nil
    } else {
      let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ScheduleHeader
      
      let yearMonth = scheduleModel.yearMonthSectionKey(section: section)
      headerView.label.text = String(format: "%d년 %d월", yearMonth/100, yearMonth%100)
      
      return headerView
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    일정이 없을때 빈화면으로 감
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
        cell.contentView.alpha = (isPast) ? 0.2 : 1.0
        cell.scheduleData = scheduleData
        cell.scheduleDayLabel.text = "\(scheduleData.scheduleDateInfo.day)일"
        //        아이콘없을을 체크한 경우 아이콘 view를 hidden 시킴
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
  // 선택한 row가 지난 일정이 아니라면 write페이지로 넘어가서 수정이 가능함
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell{
      if !getIsPast(cell.scheduleData.scheduleDateInfo) { // cell.contentView.alpha == 1.0
        self.performSegue(withIdentifier: "segueToWrite", sender: cell)
      }
    }
  }
  // 선택한 row가 지난 일정이면 selected가 안먹게 하고 싶었음
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

