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
	
	private(set) lazy var fairySearchView: FairySearchView = {
		let view = FairySearchView()
		return view
	}()
	
	override func loadView() {
		let view = self.fairySearchView
		view.frame = UIScreen.main.bounds
		view.autoresizingMask = .flexibleSize
	}
	
}

extension FairySearchViewController {
	
	func update() {
		self.fairySearchView.updateFairies()
	}
	
}
