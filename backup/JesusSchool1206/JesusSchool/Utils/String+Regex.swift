
import UIKit

extension String{
  func checkRegex(regex: String) -> Bool {
    let regex = try! NSRegularExpression(pattern: regex, options: [])
    
    return regex.matches(in: self, options: [], range: NSRange(location: 0, length: characters.count)).count > 0
  }
}
