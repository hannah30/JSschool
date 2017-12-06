
import UIKit

class WriteViewController: UIViewController, UITextViewDelegate {

  
  @IBOutlet weak var scheduleTextView: UITextView!
  @IBOutlet weak var selectedDate: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  
  let datePikcker = UIDatePicker()
  
  var scheduleData: ScheduleData?
  
  var selectedRow: Int?
  
  lazy var alamofireRepository = AlamofireRepository.main
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    selectedDate.delegate = self
    
    createDatePicker()
    
    scheduleTextView.layer.borderColor = UIColor.lightGray.cgColor
    scheduleTextView.layer.borderWidth = 1 / UIScreen.main.scale
    scheduleTextView.layer.cornerRadius = 5
  
    if let scheduleData = scheduleData {
      //modify
      selectedRow = scheduleData.scheduleIcon?.rawValue
      let dateInfo = scheduleData.scheduleDateInfo
      selectedDate.text = String(format: "%d년 %02d월 %02d일", dateInfo.year, dateInfo.month, dateInfo.day)
      scheduleTextView.text = scheduleData.scheduleContent
      submitButton.setTitle("\(currentStateString)완료", for: .normal)
    } else {
      //write
    }
}
  
  func createDatePicker() {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didTabDoneBtn))
    let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBtn = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(didTabDateCancelBtn))
    
    toolbar.setItems([doneBtn, spaceBtn, cancelBtn], animated: false)
    
    selectedDate.inputAccessoryView = toolbar
    selectedDate.inputView = datePikcker
    
    let currentDate = Date()
    
    let minDate = currentDate
    let maxDate = currentDate + ((60 * 60 * 24)*60)
    
    datePikcker.setDate(currentDate, animated: true)
    datePikcker.datePickerMode = .date
    datePikcker.minimumDate = minDate
    datePikcker.maximumDate = maxDate
    
  }
  
  @objc func didTabDateCancelBtn() {
    self.view.endEditing(true)
  }
  
  @objc func didTabDoneBtn() {
    let formetter = DateFormatter()
    formetter.dateFormat = "yyyy년 MM월 dd일"
    let dateStr = formetter.string(from: datePikcker.date)
    
    selectedDate.text = "\(dateStr)"
    self.view.endEditing(true)
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if (textView.text == "일정을 입력해 주세요.")
    {
      textView.text = ""
      textView.textColor = .black
    }
    textView.becomeFirstResponder()
  }
  
  var currentStateString: String{
    return (scheduleData == nil) ? "작성" : "수정"
  }
  
  @IBAction func didTabCancelBtn(_ sender: UIButton) {
    if scheduleTextView.text != nil {
      let alret = UIAlertController(title: "\(currentStateString)취소", message: "일정\(currentStateString)을 취소하시겠습니까?", preferredStyle: .alert)
      let alretCancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
      let alretAction = UIAlertAction(title: "확인", style: .default, handler: { (action) in
        self.dismiss(animated: true, completion: nil)
      })
      alret.addAction(alretCancelAction)
      alret.addAction(alretAction)
      present(alret, animated: true, completion: nil)
    } else {
      dismiss(animated: true, completion: nil)
      
    }
  }
  
  var dateFromTextField: Date? {
    let formetter = DateFormatter()
    formetter.dateFormat = "yyyy년 MM월 dd일"
    if let text = selectedDate.text {
      return formetter.date(from: text)
    }
    return nil
  }
  
  @IBAction func didTabWriteBtn(_ sender: UIButton) {
    if selectedRow == nil {
      //TODO 아이콘 미선택
    } else if dateFromTextField == nil {
      //TODO 날짜 미입력
    } else if scheduleTextView.text.isEmpty {
      //TODO 내용 미입력
    } else {
      if scheduleData == nil {
        //TODO write alamofireRepository
        
        let date = dateFromTextField!
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let writerId = "11111111q"
        
        let newScheduleData = ScheduleData(
          scheduleIdx: 0,
          scheduleContent: scheduleTextView.text!,
          scheduleWriterId: writerId,
          scheduleDateInfo: (year: year, month: month, day: day),
          scheduleIcon: ScheduleImoticon(rawValue: selectedRow!),
          churchCode: "")
        
        alamofireRepository.scheduleWrite(scheduleData: newScheduleData, responseClosure: {
          // TODO
          //self.dismiss(animated: true, completion: nil)
          self.performSegue(withIdentifier: "unwindSegueWriteToSchedule", sender: nil)
        })
      } else {
        //TODO modify alamofireRepository
      }
    }
    
  }
  
}

extension WriteViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return false
  }
}

extension WriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   return ScheduleImoticon.imageNames.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! WriteCollectionViewCell
    
    item.scheduleIconImgView.image = ScheduleImoticon(rawValue: indexPath.row)?.image
    
    if( selectedRow == indexPath.row){
      item.selectedIconView.isHidden = false
    }
    
    return item
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemWidthSize = (collectionView.bounds.size.width - 32) / 6
    return CGSize(width: itemWidthSize, height: itemWidthSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? WriteCollectionViewCell {
      if let selectedRow = selectedRow {
        if let beforeCell = collectionView.cellForItem(at: IndexPath.init(row: selectedRow, section: 0)) as? WriteCollectionViewCell {
          beforeCell.selectedIconView.isHidden = true
        }
      }
      if selectedRow != indexPath.row {
        cell.selectedIconView.isHidden = false
        selectedRow = indexPath.row
      } else {
        selectedRow = nil
      }
    }
  }
}

