//
//  ViewController2.swift
//  DatePickerSchedule
//
//  Created by okkoung on 2017. 12. 5..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
  
  @IBOutlet weak var ScheduleTableView: UITableView!
  @IBOutlet weak var currentDateLabel: UILabel!
  
  let scheduleModel = ScheduleModel()
  
  lazy var alamofireRepository = AlamofireRepository.main

    override func viewDidLoad() {
        super.viewDidLoad()
      
      ScheduleTableView.register(UINib(nibName: "ScheduleHeader", bundle: nil),
                                 forHeaderFooterViewReuseIdentifier: "header")
      
      ScheduleTableView.rowHeight = UITableViewAutomaticDimension
      ScheduleTableView.estimatedRowHeight = 50
      
      let nowDate = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy년 MM월"
      let currentDateStr = formatter.string(from: nowDate)
      currentDateLabel.text = currentDateStr
      
      alamofireRepository.schedules { scheduleDatas in
        
        self.scheduleModel.appendData(scheduleDatas)
        
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
      scheduleModel.clear()
      alamofireRepository.schedules { scheduleDatas in
        
        self.scheduleModel.appendData(scheduleDatas)
        
        self.ScheduleTableView.reloadData()
      }
    }
  }

}

extension ViewController2: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return scheduleModel.yearMonthCount
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ScheduleHeader
    
    let yearMonth = scheduleModel.yearMonthSectionKey(section: section)
    headerView.label.text = String(format: "%d년 %02d월", yearMonth/100, yearMonth%100)
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return scheduleModel.dayDatasCount(section: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let scheduleData = scheduleModel.dayData(section: indexPath.section, row: indexPath.row)
    
    if let cell = cell as? ScheduleTableViewCell {
      cell.scheduleData = scheduleData
      cell.scheduleDayLabel.text = "\(scheduleData.scheduleDateInfo.day)"
      cell.scheduleIconImg.image = scheduleData.scheduleIcon?.image
      cell.scheduleLabel.text = scheduleData.scheduleContent
    }
    
    return cell
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
