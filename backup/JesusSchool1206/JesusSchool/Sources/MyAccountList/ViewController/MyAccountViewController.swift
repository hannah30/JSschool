
import UIKit

class MyAccountViewController: UIViewController {
  
  let myAccounData = MyAccountData()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  
}

extension MyAccountViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return myAccounData.MyAccountHeaderData[0]
    case 1:
      return myAccounData.MyAccountHeaderData[1]
    case 2:
      return myAccounData.MyAccountHeaderData[2]
    default:
      return "정보가 없습니다"
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return myAccounData.MyAccountHeaderData.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return myAccounData.MyAccountInformation.count
    case 1:
      return myAccounData.MyAccountNotice.count
    case 2:
      return myAccounData.MyAccountLogout.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    switch indexPath.section {
    case 0:
      cell.textLabel?.text = myAccounData.MyAccountInformation[indexPath.row]
    case 1:
      cell.textLabel?.text = myAccounData.MyAccountNotice[indexPath.row]
    case 2:
      cell.textLabel?.text = myAccounData.MyAccountLogout[indexPath.row]
    default:
      break
    }
    return cell
  }
  
}

