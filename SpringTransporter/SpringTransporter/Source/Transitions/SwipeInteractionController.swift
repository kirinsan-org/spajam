//
//  SwipeInteractionController.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
	
	var interactionInProgress = false
	private var shouldCompleteTransition = false
	private weak var viewController: UIViewController?
	
	
	
	func wire(to viewController: UIViewController!) {
		self.viewController = viewController
		self.prepareGestureRecognizer(in: viewController.view)
	}
	
	private func prepareGestureRecognizer(in view: UIView) {
		let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handleGesture(gestureRecognizer:)))
		gesture.edges = .left
		view.addGestureRecognizer(gesture)
	}
	
	func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
		
		// 1
		let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
		var progress = Float(translation.x / 200)
		progress = fminf(fmaxf(progress, 0.0), 1.0)
		
		switch gestureRecognizer.state {
			
		case .began:
			// 2
			self.interactionInProgress = true
			self.viewController?.dismiss(animated: true, completion: nil)
			
		case .changed:
			// 3
			self.shouldCompleteTransition = progress > 0.5
			self.update(CGFloat(progress))
			
		case .cancelled:
			// 4
			self.interactionInProgress = false
			self.cancel()
			
		case .ended:
			// 5
			self.interactionInProgress = false
			
			if self.shouldCompleteTransition {
				print("finish")
				self.finish()
			} else {
				print("cancel")
				self.cancel()
			}
			
		default:
			print("Unsupported")
			self.cancel()
		}
	}
	
}
