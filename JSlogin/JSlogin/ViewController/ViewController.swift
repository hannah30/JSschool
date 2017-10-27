//
//  ViewController.swift
//  JSlogin
//
//  Created by okkoung on 2017. 10. 12..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate, SFSafariViewControllerDelegate {
  
  @IBOutlet weak var headCopyText: KeringLabel!
  

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    

  }
  
  
  @IBAction func didTapTermBtn(_ sender: Any) {
    let term = NSURL(string: "http://www.jesschool.com/jesschool/app_terms.html")!
    let termSapari = SFSafariViewController(url: term as URL)
    present(termSapari, animated: true, completion: nil)
  }
  
  @IBAction func didTapProvisionBtn(_ sender: Any) {
    let provision = NSURL(string: "http://www.jesschool.com/jesschool/provision.html")!
    let provisionSapari = SFSafariViewController(url: provision as URL)
    present(provisionSapari, animated: true, completion: nil)
  }
  
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    
  
  }
// UI의 어느 부분을 클릭해도 키보드가 내려가게 함
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
//키보드에 있는 return 키를 눌렀을때 키보드가 내려가게 함
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

