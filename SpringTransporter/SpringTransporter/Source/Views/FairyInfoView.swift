//
//  FairyInfoView.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit
import NotAutoLayout

protocol FairyInfoViewDataSource: class {
	
}

class FairyInfoView: LayoutView {
	
	weak var dataSource: FairyInfoViewDataSource?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initialize()
	}
	
	convenience init() {
		self.init(frame: .zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func initialize() {
		self.backgroundColor = .blue
	}
	
}
