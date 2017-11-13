
import UIKit

class SettingListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var settingListTableView: UITableView!
  
  let rowHeight: CGFloat = 80
  let headerHeight: CGFloat = 130
  let imgPiker = UIImagePickerController()
  
  var settingList: SettingListData = SettingListData()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imgPiker.delegate = self
    
  }
  
}

extension SettingListViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingList.settingList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
    
    cell.settingListImgView.image = settingList.settingListImg[indexPath.row]
    cell.textLabel?.text = settingList.settingList[indexPath.row]
    
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(rowHeight)
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(headerHeight)
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableCell(withIdentifier: "ListHeader") as! SettingListHeaderCell
    
    return header
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      performSegue(withIdentifier: "Faq", sender: nil)
    } else if indexPath.row == 1 {
      performSegue(withIdentifier: "InviteFriends", sender: nil)
    } else if indexPath.row == 2 {
      performSegue(withIdentifier: "Donation", sender: nil)
    } else if indexPath.row == 4 {
      performSegue(withIdentifier: "SayJesusSchool", sender: nil)
    } else if indexPath.row == 5 {
      performSegue(withIdentifier: "Supervisor", sender: nil)
    }
  }
}

extension SettingListViewController: SettingListHeaderCellDelegate {
  func didTabUserProfileTitleImg() {
    
    imgPiker.allowsEditing = false
    imgPiker.sourceType = .photoLibrary
    
    present(imgPiker, animated: true, completion: nil)
  }
}





