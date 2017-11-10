//
//  LoginViewController.swift
//  1106
//
//  Created by okkoung on 2017. 11. 6..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

 
  @IBOutlet weak var imgview: UIImageView!
  override func viewDidLoad() {
        super.viewDidLoad()
    
    
      
      if let data = try? Data(contentsOf: URL(string: "https://www.google.co.kr/search?q=%EC%9B%8C%EB%84%88%EC%9B%90&tbm=isch&tbo=u&source=univ&sa=X&ved=0ahUKEwin6fL9uanXAhXGopQKHSmxB98Q7AkITA&biw=1600&bih=901#imgrc=wDb-TAbuPUAE1M:")!){
        imgview.image = UIImage(data: data)
      }
      
    }
}

extension UIImageView {
  func forimageForUrl(_ url : URL) {
  if let data = Data(contentsOf: url)
  }
}
