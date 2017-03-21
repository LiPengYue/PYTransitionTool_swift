//
//  AnimatedTransition.swift
//  TransitionAnimation
//
//  Created by 李鹏跃 on 17/3/20.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class AnimatedTransition: NSObject,UIViewControllerAnimatedTransitioning {
    //一定要有UIModalPresentationStyle，看坑1
//    init(modalPresentationStyle: UIModalPresentationStyle) {
//        super.init()
//        self.modalPresentationStyle = modalPresentationStyle
//    }
    
    /// * UIModalPresentationStyle是否为自定义
    var modalPresentationStyle: UIModalPresentationStyle = .custom
    /// * isPresent: 是否为present动画
    var isPrensent: Bool = true
    /// * dismissDuration: dismiss动画预估时长
    var dismissDuration: TimeInterval = 0.0
    /// * presentDuration: present动画预估时长
    var presentDuration: TimeInterval = 0.0
    /// * 动画是否已经完成
    var isAccomplish: Bool {
        get{
            return self._isAccomplish
        }
        set (newValue){
            self._isAccomplish = newValue
            if newValue {
                self.transitionContext?.completeTransition(true)
            }
        }
    }
    

    //MARK: -------------------- 对外保露方法 ----------------------

    ///可以拿到容器视图
    /// * containerView: 容器视图，里面储存了toView与fromeView
    /// * 可以用作蒙版（默认透明）
    func containerViewCallBackFunc(containerViewCallBack: @escaping (UIView)->()) -> () {
        self.containerViewCallBack = containerViewCallBack
    }
    
    //MARK: -------------------- 动画接口 -------------------------
    
    /// * presentAnimationCallBack: 可以在里面写present转场动画 
    /// * toVC: 到那个vc去
    /// * toView: toVC的view（在ios 8.0前，可以直接获取toVC.view,但以后要根据key取）
    /// * fromVC: 从哪里来
    /// * fromView: fromVC的view（在ios 8.0前，可以直接获取fromVC.view,但以后要根据key取）
    func presentAnimationCallBackFunc(_ presentAnimationCallBack: @escaping (_ toVC: UIViewController, _ toView: UIView, _ fromVC: UIViewController, _ fromeView: UIView)->()) -> () {
        self.presentAnimationCallBack = presentAnimationCallBack
    }
    
    /// * presentAnimationCallBack: 可以在里面写present转场动画
    /// * toVC: 到那个vc去
    /// * toView: toVC的view（在ios 8.0前，可以直接获取toVC.view,但以后要根据key取）
    /// * fromVC: 从哪里来
    /// * fromView: fromVC的view（在ios 8.0前，可以直接获取fromVC.view,但以后要根据key取）
    func dismissAnimationCallBackFunc(_ dismissAnimationCallBack: @escaping (_ toVC: UIViewController, _ toView: UIView, _ fromVC: UIViewController, _ fromView: UIView) -> ()) ->() {
        self.dismissAnimationCallBack = dismissAnimationCallBack;
    }
    
    
    //MARK: ------------- 私有属性 -----------------
 
    /// * transitionContext: 以后告诉系统完成动画用的
    private var _isAccomplish: Bool = false
    /// * transitionContext: 以后告诉系统完成动画用的
    private var transitionContext: UIViewControllerContextTransitioning?
    /// * containerView 可以拿到容器视图
    private var containerViewCallBack: ((_ containerView: UIView)->())?
    
    //-------------------- 关于动画的私有属性 -----------------
    /// present
    private var presentAnimationCallBack: ((_ toVC: UIViewController, _ toView: UIView, _ fromVC: UIViewController, _ fromeView: UIView)->())?
    // dismiss
    private var dismissAnimationCallBack: ((_ toVC: UIViewController, _ toView: UIView, _ fromVC: UIViewController, _ fromeView: UIView)->())?

    
    //MARK: -------------- 动画的执行方法 -------------------
    //MARK: 返回动画时长
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPrensent ? presentDuration : dismissDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //记录transitionContext
        self.transitionContext = transitionContext
        
        //1. 获取容器视图
        let containerView = transitionContext.containerView;
        
        //2. 获取toVC & toView //坑2. dismiss时 toView为nil
        let toVC: UIViewController = transitionContext .viewController(forKey: .to)!
        let toView: UIView = transitionContext.view(forKey: .to) ?? toVC.view
        
        //3. 获取fromeVC & fromeView
        let fromVC: UIViewController = transitionContext.viewController(forKey: .from)!
        let fromView: UIView = transitionContext.view(forKey: .from) ?? fromVC.view
        
        //4. 把fromView & toView 加入容器视图
        //坑1. dismiss后黑屏了？？？
//        containerView.addSubview(fromView)
//        containerView.addSubview(toView)
        
        //MARK: -------------------- 对外接口的调用 ----------------------
        //5. 对containerView的设置
        self.containerViewCallBack?(containerView)
        
        //6. 根据是否为present 执行相应的动画
        if isPrensent {
            containerView.addSubview(toView)
            self.presentAnimationCallBack?(toVC,toView,fromVC,fromView)
        }else{
            //判断toVC的,只有在不是.custom的时候才能添加
            if self.modalPresentationStyle != .custom{
                containerView.addSubview(toView)
            }
            self.dismissAnimationCallBack?(toVC,toView,fromVC,fromView)
        }
        
        //7. 完成动画后告诉系统
        //在isAccomplish 的setter方法里
    }
}


// ------------------------- 关于一些坑：-----------------------------------
/**
 我的简书：《iOS CAAnimation之CATransition（自定义转场动画）》
 http://www.jianshu.com/p/fb0d6b0f8008
 
 //坑1. dismiss后黑屏了？？？
 Custom 模式：presentation 结束后，presentingView(fromView) 未被主动移出视图结构，在 dismissal 中，注意不要像其他转场中那样将 presentingView(toView) 加入 containerView 中，否则 dismissal 结束后本来可见的 presentingView 将会随着 containerView 一起被移除。如果你在 Custom 模式下没有注意到这点，很容易出现黑屏之类的现象而不知道问题所在。
 在 Custom 模式下的dismissal 转场（在present中要添加）中不要像其他的转场那样将 toView(presentingView) 加入 containerView，否则 presentingView 将消失不见，而应用则也很可能假死。而 FullScreen 模式下可以使用与前面的容器类 VC 转场同样的代码。因此，上一节里示范的 Slide 动画控制器不适合在 Custom 模式下使用，放心好了，Demo 里适配好了，具体的处理措施，请看下一节的处理
 
 //坑2. dismiss时 toView为nil
 iOS 8 为<UIViewControllerContextTransitioning>协议添加了viewForKey:方法以方便获取 fromView 和 toView，但是在 Modal 转场里要注意：在 Custom 模式下通过viewForKey:方法来获取 presentingView 得到的是 nil，必须通过viewControllerForKey:得到 presentingVC 后来间接获取，FullScreen 模式下没有这个问题。(原来这里没有限定是在 Custom 模式，导致 @JiongXing 浪费了些时间，抱歉)。因此在 Modal 转场中，较稳妥的方法是从 fromVC 和 toVC 中获取 fromView 和 toView。
 */
