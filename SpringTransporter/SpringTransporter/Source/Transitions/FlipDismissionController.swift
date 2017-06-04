//
//  FlipDismissionController.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit

class FlipDismissionController: NSObject {
	
	weak var originView: UIView?
	
}

extension FlipDismissionController: UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		
		return 0.5
		
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		let containerView = transitionContext.containerView
		guard let fromVC = transitionContext.viewController(forKey: .from),
			let toVC = transitionContext.viewController(forKey: .to) else {
			return
		}
		
		// 1
		let finalFrame = self.originView?.frame ?? .zero
		
		// 2
		let snapshot = UIImageView(image: UIImage.renderImage(from: fromVC.view))
		snapshot.layer.masksToBounds = true
		
		// 3
		containerView.addSubview(toVC.view)
		containerView.addSubview(snapshot)
		fromVC.view.isHidden = true
		
		AnimationHelper.perspectiveTransformForContainerView(containerView)
		
		// 4
		self.originView?.layer.transform = AnimationHelper.yRotation(-.pi / 2)
		self.originView?.isHidden = true
		
		let duration = transitionDuration(using: transitionContext)
		
		UIView.animate(withDuration: duration * 0.7, animations: {
			snapshot.frame = finalFrame
			snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
		}) { (_) in
			self.originView?.isHidden = false
			snapshot.isHidden = true
			UIView.animate(withDuration: duration * 0.3, animations: {
				self.originView?.layer.transform = AnimationHelper.yRotation(0)
			}, completion: { (_) in
				fromVC.view.isHidden = false
				snapshot.removeFromSuperview()
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			})
		}
		
	}
	
}
