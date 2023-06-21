//
//  ViewController.swift
//  KeyboardStateWrapper
//
//  Created by Lay Channara on 6/21/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardPlacementView: UIView!
    
    @KeyboardState(state: .will) var willKeyboardState
    @KeyboardState(state: .did) var didKeyboardState
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        $willKeyboardState { keyboard, show in
            let animationCurve = keyboard?["UIKeyboardAnimationCurveUserInfoKey"] as! NSNumber
            let animationDuration = keyboard?["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber
            let constant = show ? self.willKeyboardState - self.view.safeAreaInsets.bottom : self.willKeyboardState
            UIView.animate(withDuration: animationDuration.doubleValue, delay: 0.0, options: UIView.AnimationOptions(rawValue: UInt(animationCurve.uintValue << 16))) {
                self.bottomConstraint.constant = constant
                self.view.layoutIfNeeded()
            }
            
        }
        
        $didKeyboardState { keyboard, show in
            let animationCurve = keyboard?["UIKeyboardAnimationCurveUserInfoKey"] as! NSNumber
            let animationDuration = keyboard?["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber
            let constant = show ? self.didKeyboardState - self.view.safeAreaInsets.bottom : self.didKeyboardState
            UIView.animate(withDuration: animationDuration.doubleValue , delay: 0.0, options: UIView.AnimationOptions(rawValue: UInt(animationCurve.uintValue << 16))) {
                self.bottomConstraint.constant = constant
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

