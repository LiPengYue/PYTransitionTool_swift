//
//  PYModalVC.swift
//  TransitionAnimation
//
//  Created by 李鹏跃 on 17/3/21.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

import UIKit

class PYModalVC: UIViewController {
    
    let imageView = UIImageView(image: UIImage(named:"111"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        let label = UILabel(frame: CGRect.zero)
        label.frame = CGRect(x: 20, y: 50, width: 100, height: 50)
        label.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.8987278659, blue: 0.8579486714, alpha: 1)
        label.textAlignment = .center
        view.addSubview(label)
        label.text = "toVC"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
