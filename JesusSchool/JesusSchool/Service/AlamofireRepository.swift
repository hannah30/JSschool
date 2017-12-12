
import Foundation
import Alamofire

enum JoinCheckType: String {
  case id
  case nick
  case phone
  
  var fieldName: String {
    switch self {
    case .id:
      return "user_id"
    case .nick:
      return "user_nick"
    case .phone:
      return "user_phone"
    }
  }
}

enum JoinCheckResult: String{
  case empty = "N"
  case exist = "exist"
  case avaliable = "Y"
}
//로그인 성공여부 체크 메시지
enum LoginCheckResult: String{
  case succ = "Y"
  case fail = "N"
}

struct MsgResponseData: Decodable {
  var msg: String
}

struct MsgIdResponseData: Decodable {
  var msg: String
  var userId: String
  
  // Decoding (JSON -> MODEL)
  enum CodingKeys: String, CodingKey {
    case msg
    case userId = "user_id"
  }
}


// DataRequest로 오는  error handling
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
// id, nick, phone -> db에 중복, 빈문자열, 사용가능여부를 체크하여 메시지를 보내줌
  func checkField(checkType: JoinCheckType, fieldValue: String, responseClosure: @escaping ((JoinCheckResult)->Void)) {
    Alamofire.request(BASE_URL+"/check.html", method: .post,
                      parameters: [
                        "check_type": checkType.rawValue,
                        checkType.fieldName: fieldValue
                      ]
      ).responseJesusSchool(completionHandler: { error, data in
        
        if  let data = data,
            let rData = try? JSONDecoder().decode(MsgResponseData.self, from: data) {
          // Data -> JoinResponseData
          
          if let joinCheckResult = JoinCheckResult(rawValue: rData.msg) {
            // msg문자열 -> enum JoinCheckResult
            responseClosure(joinCheckResult)
            //
          }
          
        }
        
      })
  }

  func join(id: String, password: String, nickname: String, phoneNumber: String, responseClosure: @escaping ((JoinCheckResult, String, String)->Void)) {
    Alamofire.request(BASE_URL+"/check.html", method: .post, parameters: [ "check_type": "join",
      "user_id": id, "user_nick": nickname, "user_pass": password, "user_phone": phoneNumber])
      .responseJesusSchool(completionHandler: { error, data in
        
        if  let data = data,
          let rData = try? JSONDecoder().decode(MsgIdResponseData.self, from: data) {
          // Data -> JoinResponseData
          
          if let joinCheckResult = JoinCheckResult(rawValue: rData.msg) {
            // msg문자열 -> enum JoinCheckResult
            responseClosure(joinCheckResult, id, password)
          }
          
        }
        
      })
  }
  
  func login(id: String, password: String, responseClosure: @escaping ((LoginCheckResult)->Void) ) {
    //https://jesuskids.cafe24.com/m/api/login.html
    Alamofire.request(BASE_URL+"/login.html", method: .post, parameters: [ "user_id": id, "user_pass": password])
      .responseJesusSchool(completionHandler: { error, data in
        
        if  let data = data,
          let rData = try? JSONDecoder().decode(MsgIdResponseData.self, from: data) {
          
          if let loginCheckResult = LoginCheckResult(rawValue: rData.msg) {
            responseClosure(loginCheckResult)
          }
          
        }
        
      })
  }
  
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







