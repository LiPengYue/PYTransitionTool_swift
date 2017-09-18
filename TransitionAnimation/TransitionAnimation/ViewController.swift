//
//  ViewController.swift
//  TransitionAnimation
//
//  Created by 李鹏跃 on 17/3/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

import UIKit

class ViewController: UIViewController,UIViewControllerTransitioningDelegate {
    
    
    let animatr: Animatr = Animatr.init(modalPresentationStyle: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: UIImage(named:"333"))
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: 300, y: 0, width: 100, height: 50))
        view.addSubview(label)
        label.text = "fromeVC"
        label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        self.setupAnimater()//设置动画
        self.setupButton()//设置button
        
    }
    
    private func setupButton() -> () {
        let button: UIButton = UIButton.init(frame: CGRect(x: 0, y: 50, width: 100, height: 50))
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.setTitle("点我modal", for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc private func clickButton(button: UIButton) -> () {
        let pyModalVC = PYModalVC()
        //在这里设置modal的present样式
        pyModalVC.modalPresentationStyle = .custom
        pyModalVC.transitioningDelegate = animatr
        self.present(pyModalVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



//MARK: 动画设置
private extension ViewController {
    func setupAnimater() {
        self.animatr.dismissDuration = 2.0
        self.animatr.presentDuration = 5.0
        
        self.animatr.containerViewCallBackFunc { (containerView) in
            containerView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        }
        
        self.animatr.presentAnimationCallBackFunc { (toVC, toView, formVC, fromView) in
            toView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5);
            self.animatr.isAccomplish = true
        }
        
        self.animatr.dismissAnimationCallBackFunc { (toVC, toView, fromVC, fromView) in
            //判断toVC的,只有在不是.custom的时候才能添加
            UIView.animate(withDuration: 2.0, animations: {
                fromView.transform = CGAffineTransform.identity;
            }, completion: { (isCompletion) in
                self.animatr.isAccomplish = true
            })
        }
    }
    
}
