
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
}


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







