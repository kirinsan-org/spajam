//
//  FlipPresentationController.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit

class FlipPresentationController: NSObject {
	
	weak var originView: UIView?
	
}

extension FlipPresentationController: UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		
		return 0.5
		
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		let containerView = transitionContext.containerView
		
		// 1
		guard let toVC = transitionContext.viewController(forKey: .to) else {
			return
		}
		
		// 2
		let finalFrame = transitionContext.finalFrame(for: toVC)
		let initialFrame = self.originView?.frame ?? finalFrame
		
		// 3
		guard let snapshotImage = UIImage.renderImage(from: toVC.view) else {
			return
		}
		let snapshot = UIImageView(image: snapshotImage)
		snapshot.frame = initialFrame
		snapshot.layer.masksToBounds = true
		snapshot.layer.zPosition = 100
		snapshot.isHidden = true
		
		containerView.addSubview(toVC.view)
		containerView.addSubview(snapshot)
		toVC.view.isHidden = true
		
		AnimationHelper.perspectiveTransformForContainerView(containerView)
		snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
		
		// 1
		let duration = self.transitionDuration(using: transitionContext)
		
		UIView.animate(withDuration: duration / 2, animations: {
			self.originView?.layer.transform = AnimationHelper.yRotation(-.pi / 2)
		}) { (_) in
			snapshot.isHidden = false
			UIView.animate(withDuration: duration / 2, animations: {
				snapshot.layer.transform = AnimationHelper.yRotation(0.0)
				snapshot.frame = finalFrame
				snapshot.layer.cornerRadius = 0
			}, completion: { (_) in
				toVC.view.isHidden = false
				self.originView?.layer.transform = AnimationHelper.yRotation(0.0)
				snapshot.removeFromSuperview()
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			})
		}
		
	}
	
}
