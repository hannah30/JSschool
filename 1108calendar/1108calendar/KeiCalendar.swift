import UIKit


@objc protocol KeiCalendarDalegate {
  
  @objc optional func calendar(_ calendar: KeiCalendar, didSelectedDate: Date)
}

class KeiCalendar: UIView {
  
  var delegate: KeiCalendarDalegate?
  
  var year: Int?
  var month: Int?
  
  //Mark : - property
  var date: Date? {
    willSet{
      calendarData = KeiCalendatDataModel(date: newValue!)
      year = calendarData?.year
      month = calendarData?.month
      contentsView.reloadData()
    }
  }
  
  private var calendarData: KeiCalendatDataModel?
  
  //Mark : - Private property
  private var contentsView: UICollectionView = {
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    var collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
    //collectionView 속성 추가 가능
    //여기는 인스턴스만 생성중이라 아직 self가 만들어지기 전임. 그래서 self를 못쓰니 따로 만들어 줘야 함
    collection.backgroundColor = .clear
    return collection
  }()
  private let cellIdentifier = "cell"
  
  //Mark : - init
  override func awakeFromNib() {
    setupUI()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  func updateNextMonth() {
    date = KeiCalendarManager.nextMonth(with: calendarData!)
  }
  
  func updatePrevMonth() {
    date = KeiCalendarManager.previousMonth(with: calendarData!)
  }
  
  //Mark : - private method
  //UI 관련 setup이 필요한 경우
  private func setupUI() {
    self.addSubview(contentsView)
    contentsView.delegate = self
    contentsView.dataSource = self
    contentsView.register(CustomCell.self, forCellWithReuseIdentifier: cellIdentifier)
    updateLayout()
  }
  private func updateLayout() {
//    frame base로 안쓰겠다는 의미, 이걸 꼭 해야 autolayout이 먹음.
    contentsView.translatesAutoresizingMaskIntoConstraints = false
//    contentsView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//    contentsView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//    contentsView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//    contentsView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//    contentsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30)
    contentsView.constraint(targetView: self, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
  }
}

//collection delegate
extension KeiCalendar: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return 7
    } else {
      if let calendarData = calendarData {
        return calendarData.lastDayOfMonth + calendarData.startWeekOfMonth.rawValue - 1
      } else {
        return 0
      }
    }
    
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCell
    
    cell.initUI()
    
    if indexPath.section == 0 {
      cell.titleLB.text = WeekDay(rawValue: indexPath.item)?.name
    } else {
      let changedIndex = indexPath.item - calendarData!.startWeekOfMonth.rawValue
      if changedIndex >= 0 {
        let day = changedIndex + 1
        cell.titleLB.text = "\(day)"
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.size.width / 7
    if indexPath.section == 0 {
      return CGSize(width: width, height: 30)
    } else {
//      let height = (collectionView.frame.size.height - 30) / 5
      return CGSize(width: width, height: width)
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

class CustomCell: UICollectionViewCell {
  
  var titleLB: UILabel = {
    let lb = UILabel()
    lb.textAlignment = .center
    return lb
  }()
//  재사용을 초기화 시켜주는 값을 넣어주기
  func initUI() {
    titleLB.text = ""
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  private func setupUI() {
    self.addSubview(titleLB)
    updateLayout()
//    autolayout은 꼭 addsubview후에 해야해서 여기 써주는게 좋다
    
  }
  
  private func updateLayout() {
    //    frame base로 안쓰겠다는 의미, 이걸 꼭 해야 autolayout이 먹음.
    titleLB.translatesAutoresizingMaskIntoConstraints = false
    titleLB.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    titleLB.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    titleLB.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    titleLB.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    //    contentsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30)
//    titleLB.centerXAnchor.constraint(equalTo: self.centerXAnchor)
//    titleLB.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//    titleLB.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0)
//    titleLB.heightAnchor.constraint(equalTo: self.heightAnchor)
//    밑에 함수로 만들어두면 일일이 안만들고 필요할때마다 가져다 쓰면 됨
//    titleLB.constraint(targetView: self, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
    
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
}


extension UIView {
  func constraint(targetView: UIView, topConstant: CGFloat?, bottomConstant: CGFloat?, leftConstant: CGFloat?, rightConstant: CGFloat?) {
    self.translatesAutoresizingMaskIntoConstraints = false
    if let constant = topConstant {
      self.topAnchor.constraint(equalTo: targetView.topAnchor, constant: constant).isActive = true
    }
    if let constant = bottomConstant {
      self.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: constant).isActive = true
    }
    if let constant = leftConstant {
      self.leftAnchor.constraint(equalTo: targetView.leftAnchor, constant: constant).isActive = true
    }
    if let constant = rightConstant {
      self.rightAnchor.constraint(equalTo: targetView.rightAnchor, constant: constant).isActive = true
    }
  }
  func constraint(targetView: UIView, widthSize: CGFloat?, heightSize: CGFloat?) {
//    여기도 각각  width, height에 관한 constraint를 잡아 둘수 있다.
    if let width = widthSize {
      self.widthAnchor.constraint(equalTo: targetView.widthAnchor).isActive = true
    }
    if let height = heightSize {
      self.heightAnchor.constraint(equalTo: targetView.heightAnchor).isActive = true
    }
  }
}







