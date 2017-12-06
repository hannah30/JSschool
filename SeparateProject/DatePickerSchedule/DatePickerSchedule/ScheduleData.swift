
import UIKit

struct ScheduleData: Decodable {
  let scheduleIdx: Int
  let scheduleContent: String
  let scheduleWriterId: String
  
  let scheduleDateInfo: (year: Int, month: Int, day: Int)
  let scheduleIcon: ScheduleImoticon?
  
  let churchCode: String
  
  enum CodingKeys: String, CodingKey {
    case scheduleIdx = "idx"
    case scheduleDate = "schedule_date"
    case scheduleIcon = "schedule_type"
    case scheduleContent = "schedule_info"
    case scheduleWriterId = "schedule_id"
    case churchCode = "church_code"
  }
  
  init( scheduleIdx: Int, scheduleContent: String, scheduleWriterId: String, scheduleDateInfo: (year: Int, month: Int, day: Int), scheduleIcon: ScheduleImoticon?, churchCode: String ){
    self.scheduleIdx = scheduleIdx
    self.scheduleContent = scheduleContent
    self.scheduleWriterId = scheduleWriterId
    self.scheduleDateInfo = scheduleDateInfo
    self.scheduleIcon = scheduleIcon
    self.churchCode = churchCode
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let scheduleIdxString = try container.decode(String.self, forKey: .scheduleIdx)
    scheduleIdx = Int(scheduleIdxString)!
    scheduleContent = try container.decode(String.self, forKey: .scheduleContent)
    scheduleWriterId = try container.decode(String.self, forKey: .scheduleWriterId)
    
    let scheduleDate = try container.decode(String.self, forKey: .scheduleDate)
    let dateStringSplit = scheduleDate.split(separator: "-")
    let year = Int(dateStringSplit[0])!
    let month = 11//Int(dateStringSplit[1])!
    let day = Int(dateStringSplit[2])!
    scheduleDateInfo = (year: year, month: month, day: day)
    
    let scheduleIconString = try container.decode(String.self, forKey: .scheduleIcon)

    if let scheduleIconInt = Int(scheduleIconString) {
      scheduleIcon = ScheduleImoticon(rawValue: scheduleIconInt)
    } else {
      scheduleIcon = nil
    }
    
    churchCode = (try? container.decode(String.self, forKey: .churchCode)) ?? "CODE"
  }
  
}

enum ScheduleImoticon: Int {
  case imoticon0 = 0
  case imoticon1
  case imoticon2
  case imoticon3
  case imoticon4
  case imoticon5
  case imoticon6
  case imoticon7
  case imoticon8
  case imoticon9
  case imoticon10
  
  static let imageNames = [
    "plan_icon0",
    "plan_icon1",
    "plan_icon2",
    "plan_icon3",
    "plan_icon4",
    "plan_icon5",
    "plan_icon6",
    "plan_icon7",
    "plan_icon8",
    "plan_icon9",
    "plan_icon10"
  ]
  
  var image: UIImage? {
    return UIImage(named: ScheduleImoticon.imageNames[self.rawValue])
  }
}

