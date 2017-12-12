
import Foundation
import Alamofire

extension DataRequest {
  func responseJesusSchool(completionHandler: @escaping ((Error?, Data?)->Void)){
    responseJSON { response in
      if let error = response.error {
        print(error.localizedDescription)
        completionHandler(error, nil)
      } else {
        if  let data = response.data{
          completionHandler(nil, data)
        }
        print("\(response.value ?? 0)")
      }
    }
  }
}

class AlamofireRepository {
  
  let BASE_URL = "https://jesuskids.cafe24.com/m/api"
  
  static let main = AlamofireRepository()
  
  fileprivate init() {}
  
  // GET
  // /schedule_in.html
  // churchCode "AAA"
  
  func schedules( responseClosure: @escaping (([ScheduleData])->Void) ) {
    Alamofire.request(BASE_URL+"/schedule_list.html", method: .get, parameters: [ "church_code": 1 ])
      .responseJesusSchool(completionHandler: { error, data in
        
        if  let data = data,
          let rData = try? JSONDecoder().decode(Array<ScheduleData>.self, from: data) {
          
          responseClosure(rData)
          
        }
        
      })
  }
  
  // GET
  // /schedule_write.html
  
  func scheduleWrite( scheduleData: ScheduleData, responseClosure: @escaping (([ScheduleData])->Void) ) {
    Alamofire.request(BASE_URL+"/schedule_in.html", method: .get, parameters: [
      "schedule_type": scheduleData.scheduleIcon!.rawValue,
      "schedule_info": scheduleData.scheduleContent,
      "schedule_date": String(format: "%d-%02d-%02d",
                              scheduleData.scheduleDateInfo.year,
                              scheduleData.scheduleDateInfo.month,
                              scheduleData.scheduleDateInfo.day),
      "schedule_id": "watasikei",
      "church_code": 1])
      .responseJesusSchool(completionHandler: { error, data in
        
        if  let data = data,
          let rData = try? JSONDecoder().decode(Array<ScheduleData>.self, from: data) {
          
          responseClosure(rData)
          
        }
        
      })
  }
  
  // GET
  // /schedule_modify.html
  // idx 123
  // write같음
  
  func scheduleModify( scheduleData: ScheduleData, responseClosure: @escaping (([ScheduleData])->Void) ) {
    Alamofire.request(BASE_URL+"/schedule_modify.html", method: .get, parameters: [
      "schedule_type": scheduleData.scheduleIcon!.rawValue,
      "schedule_info": scheduleData.scheduleContent,
      "idx": scheduleData.scheduleIdx,
      "schedule_id": "watasikei",
      "church_code": 1])
      .responseJesusSchool(completionHandler: { error, data in
        
        if  let data = data,
          let rData = try? JSONDecoder().decode(Array<ScheduleData>.self, from: data) {
          
          responseClosure(rData)
          
        }
        
      })
  }
}


/*class Stack<T>{
  private var arr = [T]()
  func push(item: T){
    arr.insert(item, at: 0)
  }
  func pop() -> T{
    return arr.remove(at: 0)
  }
  var length: Int {
    return arr.count
  }
}*/


/*
 [
 {
 idx: 1,
 time: 20171105,
 content: "mmmm",
 icon: 5
 },
 {
 idx: 2,
 time: 20171105,
 content: "kkkk",
 icon: 3
 }
 ]
 
 [GET] ~~~~/schedules?year=2017&month=11
   한달 일정
 
 [POST] ~~~~/schedule/insert
   icon: 3
   content: "aaa"
   time: 20171105
 
 [POST] ~~~~/schedule/delete
   idx: 1
 
 */







