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
	fileprivate let flipPresentationController = FlipPresentationController()
	fileprivate let flipDismissionController = FlipDismissionController()
	
	private(set) lazy var fairySearchView: FairySearchView = {
		let view = FairySearchView()
		return view
	}()
	
	let fairySearchEngine: DummyFairySearchEngine = {
		let engine = DummyFairySearchEngine()
		return engine
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
		self.fairySearchView.dataSource = self.fairySearchEngine
		self.setupFairyIconOnTappedAction()
		self.update()
	}
	
}

extension FairySearchViewController {
	
	private func presentInfoViewController() {
		let controller = FairyInfoViewController(dataSource: self.fairySearchEngine)
		controller.transitioningDelegate = self
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

extension FairySearchViewController: UIViewControllerTransitioningDelegate {
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		let controller = self.flipPresentationController
		controller.originView = self.tappedIcon
		return controller
		
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		defer {
			self.tappedIcon = nil
		}
		
		let controller = self.flipDismissionController
		controller.originView = self.tappedIcon
		return controller
		
	}
	
}
