//
//  ViewController.swift
//  TransitionAnimation
//
//  Created by 李鹏跃 on 17/3/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    
    let animatr: Animatr = Animatr.init(modalPresentationStyle: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAnimater()//设置动画
        self.setupButton()//设置button
        
    }
   
      private func setupButton() -> () {
        let button: UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.addTarget(self, action: #selector(clickButton), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
    }

     @objc private func clickButton(button: UIButton) -> () {
        let pyModalVC = PYModalVC()
        //在这里设置modal的present样式
        pyModalVC.modalPresentationStyle = .custom
        pyModalVC.transitioningDelegate = self.animatr
        self.present(pyModalVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
private extension ViewController {
        func setupAnimater() ->() {
        self.animatr.dismissDuration = 2.0
        self.animatr.presentDuration = 5.0
        
        self.animatr.containerViewCallBackFunc { (containerView) in
            containerView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            containerView.alpha = 0.6
        }
        
        
        self.animatr.presentAnimationCallBackFunc { (toVC, toView, formVC, fromView) in
            toView.frame = CGRect(x: -100, y: -100, width: 100, height: 100)
            toView.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            
            UIView.animate(withDuration: 5.0, animations: {
                
                toView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
                
            }, completion: { (isCompletion) in
                self.animatr.isAccomplish = true
            })
        }
        
        
        self.animatr.dismissAnimationCallBackFunc { (toVC, toView, fromVC, fromView) in
            UIView.animate(withDuration: 2.0, animations: {
                
                fromView.frame = CGRect(x: 300, y: 300, width: 10, height: 10)
                
            }, completion: { (isCompletion) in
                self.animatr.isAccomplish = true
            })
        }
    }

}
