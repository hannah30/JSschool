//
//  RightInStoryboardSegue.swift
//  JesusSchool
//
//  Created by okkoung on 2017. 11. 29..
//  Copyright © 2017년 okkoung. All rights reserved.
//

import UIKit

class RightInStoryboardSegue: UIStoryboardSegue {
  override func perform() {
    
    source.view.superview?.insertSubview(destination.view, aboveSubview: source.view)
    destination.view.frame.origin.x = source.view.bounds.width
    
    UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear,
                   animations: { self.destination.view.frame.origin.x -= self.source.view.bounds.width },
                  completion: { finished in
        self.source.present(self.destination, animated: false, completion:  nil)
    })
  }
}
