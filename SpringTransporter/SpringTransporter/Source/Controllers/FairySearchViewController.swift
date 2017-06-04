//
//  FairySearchViewController.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/03.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit
import NotAutoLayout
import Eltaso

final class FairySearchViewController: UIViewController {
	
	weak var tappedIcon: FairyIcon?
	fileprivate let flipTransitionController = FlipTransitionController()
	fileprivate let swipeInteractionController = SwipeInteractionController()
	
	private(set) lazy var fairySearchView: FairySearchView = {
		let view = FairySearchView()
		return view
	}()
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.initialize()
	}
	
	convenience init() {
		self.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func initialize() {
		
	}
	
	override func loadView() {
		let view = self.fairySearchView
		view.frame = UIScreen.main.bounds
		view.autoresizingMask = .flexibleSize
		self.view = view
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        SensorScanner.shared.delegate = self
		self.fairySearchView.dataSource = SensorScanner.shared
		self.setupFairyIconOnTappedAction()
		self.update()
	}
	
}

extension FairySearchViewController {
	
	private func presentInfoViewController() {
        guard let sensor = SensorScanner.shared.sensors.first else {
            return
        }
		let controller = FairyInfoViewController(dataSource: sensor)
        sensor.delegate = controller
		controller.transitioningDelegate = self
//		self.swipeInteractionController.wire(to: controller) //FIXME: Wierd cancel process
		self.present(controller, animated: true, completion: nil)
	}
	
	fileprivate func setupFairyIconOnTappedAction() {
		self.fairySearchView.setOnFairyTappedAction { (icon) in
			self.tappedIcon = icon
			self.presentInfoViewController()
		}
	}
	
}

extension FairySearchViewController {
	
	fileprivate func update() {
		self.fairySearchView.updateFairies()
	}
	
}

extension FairySearchViewController: SensorScannerDelegate {
    func sensorScanner(_ sensorScanner: SensorScanner, didFind sensor: Sensor) {
        update()
    }

    func sensorScanner(_ sensorScanner: SensorScanner, didLost sensor: Sensor) {
        return
    }
}

extension FairySearchViewController: UIViewControllerTransitioningDelegate {
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		defer {
			self.tappedIcon = nil
		}
		
		let controller = self.flipTransitionController
		controller.transition = .present
		controller.originView = self.tappedIcon
		return controller
		
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		let controller = self.flipTransitionController
		controller.transition = .dismiss
		return controller
		
	}
	
	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return self.swipeInteractionController.interactionInProgress ? self.swipeInteractionController : nil
	}
	
}
