//
//  Animation.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 1/11/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import Foundation
import UIKit

struct Animation {
    
    static func animateIn(mainView: UIView!, subView: UIView!) {
        mainView.addSubview(subView)
        subView.center = mainView.center
        
        subView.transform = CGAffineTransform.init(translationX: 1.3, y: 1.3)
        subView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            subView.alpha = 1
            subView.transform = CGAffineTransform.identity
        }
    }
    
    static func animateOut(subView: UIView!) {
        UIView.animate(withDuration: 0.3, animations: {
            subView.transform = CGAffineTransform.init(translationX: 1.3, y: 1.3)
            subView.alpha = 0
        }) {(success:Bool) in
            subView.removeFromSuperview()
        }
    }
}
