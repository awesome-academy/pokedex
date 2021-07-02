//
//  UIViewController.swift
//  PokedexApp
//
//  Created by Phong Le on 02/07/2021.
//

import UIKit

extension UIViewController {
    func transitionVc(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let transition = CATransition()
        
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        if let view = view.window {
            view.layer.add(transition, forKey: kCATransition)
            present(vc, animated: false, completion: nil)
        }
    }
    
    func dismissDetail(duration: CFTimeInterval, type: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        
        if let view = view.window {
            view.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
        }
    }
}
