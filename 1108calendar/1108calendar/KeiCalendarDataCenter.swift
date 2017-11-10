
import Foundation

enum WeekDay: Int {
  
  case Sun = 0, Mon, Tue, Wed, Thu, Fri, Sat
  
  var name: String {
    switch self {
    case .Sun:
      return "Sun"
    case .Mon:
      return "Mon"
    case .Tue:
      return "Tue"
    case .Wed:
      return "Wed"
    case .Thu:
      return "Thu"
    case .Fri:
      return "Fri"
    case .Sat:
      return "Sat"
    }
  }
}

class KeiCalendarManager {
  class func nextMonth(with dateModel: KeiCalendatDataModel) -> Date {
    let myCalendar = Calendar(identifier: .gregorian)
    var newComponents = DateComponents()
    newComponents.year = dateModel.year
    newComponents.month = dateModel.month + 1
    newComponents.day = dateModel.day
    
    if let nextDate = myCalendar.date(from: newComponents) {
      return nextDate
    } else {
      return Date()
    }
  }
  class func previousMonth(with nowDate: Date) -> Date? {
    let myCalendar = Calendar(identifier: .gregorian)
    var addComponents = DateComponents()
    addComponents.month = -1
    
    guard let newDate = myCalendar.date(byAdding: addComponents, to: nowDate) else { return nil }
    return newDate
  }
}


struct KeiCalendatDataModel {
  var year: Int
  var month: Int
  var day: Int
  
  var startWeekOfMonth: WeekDay
  var lastDayOfMonth: Int
  
  init?(date: Date) {

    let myCalendar = Calendar(identifier: .gregorian)
    var components = myCalendar.dateComponents([.year, .month, .day], from: date)
    year = components.year ?? 0
    month = components.month ?? 0
    day = components.day ?? 0
//    components.month += 1 담달
    components.day = 1
    
//    각 년월의 1일인 date
    guard let firstDayDate = myCalendar.date(from: components) else { return nil }
//    1을 통해서 요일을 알려줌 (근데 요일의  Int값을 알려줌)
    var weekDayCompo = myCalendar.dateComponents([.weekday], from: firstDayDate)
    
    //    test
    
    startWeekOfMonth = WeekDay.init(rawValue: weekDayCompo.weekday! - 1)!
    
    var addComponents = DateComponents()
    addComponents.month = 1
    addComponents.day = -1
    
    guard let lastDayDate = myCalendar.date(byAdding: addComponents, to: firstDayDate) else { return nil }
    lastDayOfMonth = myCalendar.dateComponents([.day], from: lastDayDate).day ?? 1
  }
}






