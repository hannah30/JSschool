import UIKit
import PagingKit
//PagingKit을 이용해 전체 뷰콘과 메뉴 슬라이드를 여기서 관리함
class MainPageControllViewController: UIViewController {
  
  var menuViewController: PagingMenuViewController!
  var contentViewController: PagingContentViewController!
  
  var firstViewController = NewsViewController()
  
  var contentsDatasource: [(menuTitle: String, vc: UIViewController)]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpViewController()
    
    menuViewController.register(nib: UINib(nibName: "MainMenuCell", bundle: nil), forCellWithReuseIdentifier: "MainMenuCell")
    menuViewController.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
    
    menuViewController.reloadData(with: 0)
    contentViewController.reloadData(with: 0)
  }
//  각각 main contents가 될 뷰콘&타이틀 생성
  func setUpViewController(){
    let mainStotyboard = UIStoryboard(name: "Main", bundle: nil)
    let newsVC = mainStotyboard.instantiateViewController(withIdentifier: "News")
    let attendanceVC = mainStotyboard.instantiateViewController(withIdentifier: "Attendance")
    let scheduleVC = mainStotyboard.instantiateViewController(withIdentifier: "Schedule")
    let settingStotyboard = UIStoryboard(name: "Setting", bundle: nil)
    let thisIsVC = settingStotyboard.instantiateViewController(withIdentifier: "ThisisSetting")
    
    contentsDatasource = [
      (menuTitle: "소식", vc: newsVC),
      (menuTitle: "출석", vc: attendanceVC),
      (menuTitle: "일정", vc: scheduleVC),
      (menuTitle: "더보기", vc: thisIsVC),
    ]
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? PagingMenuViewController {
      menuViewController = vc
      menuViewController.dataSource = self
      menuViewController.delegate = self
      
    } else if let vc = segue.destination as? PagingContentViewController {
      contentViewController = vc
      contentViewController.dataSource = self
      contentViewController.delegate = self
    }
  }
  
  
}

extension MainPageControllViewController: PagingMenuViewControllerDataSource {
  func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
    return contentsDatasource?.count ?? 0
  }
  
  func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
    let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MainMenuCell", for: index) as! MainMenuCell
    cell.MainTopTitleLabel.text = contentsDatasource?[index].menuTitle
    return cell
  }
  
  func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
    return self.view.bounds.size.width / CGFloat(contentsDatasource?.count ?? 1)
  }
  
  
}

extension MainPageControllViewController: PagingContentViewControllerDataSource {
  func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
    return contentsDatasource?.count ?? 0
  }
  
  func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
    return contentsDatasource![index].vc
  }
}

extension MainPageControllViewController: PagingContentViewControllerDelegate {
  func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
    menuViewController.scroll(index: index, percent: percent, animated: false)
  }
}

extension MainPageControllViewController: PagingMenuViewControllerDelegate {
  func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
    contentViewController.scroll(to: page, animated: true)
  }
}
