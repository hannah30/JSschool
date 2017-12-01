
import UIKit

class SettingListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var settingListTableView: UITableView!
  @IBOutlet weak var headerView: SettingListHeader!
  
  let rowHeight: CGFloat = 80
  let imgPiker = UIImagePickerController()
  
  var settingList: SettingListData = SettingListData()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imgPiker.delegate = self
    headerView.delegate = self
    
    //    settingListTableView.rowHeight = UITableViewAutomaticDimension
    //    settingListTableView.estimatedRowHeight = 10
    
    
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let pickerImg = info[UIImagePickerControllerOriginalImage] as! UIImage
    headerView.userProfileTitleImg.image = pickerImg
    dismiss(animated: true, completion: nil)
  }
}
extension SettingListViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingList.settingList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
    
    cell.settingListImgView.image = settingList.settingListImg[indexPath.row]
    cell.settingListCellTitle.text = settingList.settingList[indexPath.row]
    
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(rowHeight)
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

extension SettingListViewController: SettingListHeaderDelegate {
  
  func didTabUserProfileTitleImg() {
    imgPiker.allowsEditing = false
    imgPiker.sourceType = .photoLibrary
    present(imgPiker, animated: true, completion: nil)
  }
}





