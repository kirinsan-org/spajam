//
//  FlipTransitionController.swift.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit
import Eltaso

class FlipTransitionController: NSObject {
	
	enum Transition {
		case present
		case dismiss
	}
	
	var transition: Transition = .present
	
	fileprivate var originalFrame: CGRect? = nil
	weak var originView: UIView? {
		didSet {
			self.didUpdateOriginView()
		}
	}
	
}

extension FlipTransitionController {
	
	fileprivate func didUpdateOriginView() {
		
		guard let originView = self.originView else {
			self.originalFrame = nil
			return
		}
		
		self.originalFrame = originView.frame
		
	}
	
}

extension FlipTransitionController {
	
	func centerFrame(of view: UIView?, in baseView: UIView) -> CGRect {
		
		let baseViewBounds = baseView.bounds
		let size = view?.frame.size ?? .zero
		let x = (baseViewBounds.width - size.width) / 2
		let y = (baseViewBounds.height - size.height) / 2
		let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
		return frame
		
	}
	
}

extension FlipTransitionController {
	
	fileprivate func present(using transitionContext: UIViewControllerContextTransitioning) {
		
		let containerView = transitionContext.containerView
		
		guard let toVC = transitionContext.viewController(forKey: .to) else {
			return
		}
		
		let finalFrame = transitionContext.finalFrame(for: toVC)
		let initialFrame = self.centerFrame(of: self.originView, in: containerView)
		
		guard let snapshotImage = UIImage.renderImage(from: toVC.view) else {
			return
		}
		let snapshot = UIImageView(image: snapshotImage)
		snapshot.layer.zPosition = 100
		snapshot.frame = initialFrame
		
		containerView.addSubview(toVC.view)
		containerView.addSubview(snapshot)
		toVC.view.isHidden = true
		
		AnimationHelper.perspectiveTransformForContainerView(containerView)
		snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
		
		let duration = self.transitionDuration(using: transitionContext)
		
		UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
			
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
				self.originView?.frame = initialFrame
				self.originView?.layer.transform = AnimationHelper.yRotation(-.pi / 2)
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7, animations: {
				snapshot.layer.transform = AnimationHelper.yRotation(0.0)
				snapshot.frame = finalFrame
			})
			
		}) { (_) in
			toVC.view.isHidden = false
			self.originView?.layer.transform = AnimationHelper.yRotation(0.0)
			snapshot.removeFromSuperview()
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}
		
	}
	
	fileprivate func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
		
		let containerView = transitionContext.containerView
		guard let fromVC = transitionContext.viewController(forKey: .from),
			let toVC = transitionContext.viewController(forKey: .to) else {
				return
		}
		
		let snapshot = UIImageView(image: UIImage.renderImage(from: fromVC.view))
		snapshot.layer.zPosition = 100
		
		let initialFrame = self.centerFrame(of: self.originView, in: containerView)
		
		containerView.addSubview(toVC.view)
		containerView.addSubview(snapshot)
		fromVC.view.isHidden = true
		
		AnimationHelper.perspectiveTransformForContainerView(containerView)
		
		self.originView?.frame = initialFrame
		self.originView?.layer.transform = AnimationHelper.yRotation(-.pi / 2)
		
		let duration = transitionDuration(using: transitionContext)
		
		UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: { 
			
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
				snapshot.frame = initialFrame
				snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
				self.originView?.layer.transform = AnimationHelper.yRotation(0)
				self.originView?.frame =? self.originalFrame
			})
			
		}) { (_) in
			fromVC.view.isHidden = false
			snapshot.removeFromSuperview()
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}
		
	}
	
}

extension FlipTransitionController: UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		
		return 0.5
		
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		switch self.transition {
		case .present:
			self.present(using: transitionContext)
			
		case .dismiss:
			self.dismiss(using: transitionContext)
		}
		
	}
	
}
