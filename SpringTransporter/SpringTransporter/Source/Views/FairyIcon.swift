//
//  FairyIcon.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/03.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit
import Danbo

final class FairyIcon: UIButton {
	
	let name: String
	var signalStrength: Double {
		didSet {
			self.signalStrengthDidChange()
		}
	}
	
	private var onTapped: ((FairyIcon) -> Void)?
	
	init(name: String, signalStrength: Double) {
		
		self.name = name
		self.signalStrength = signalStrength
		
		super.init(frame: .zero)
		
		self.initialize()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func initialize() {
		self.backgroundColor = .red
		self.addTarget(self, action: #selector(self.onTappedCall), for: .touchUpInside)
	}
	
	func setOnTappedAction(_ action: @escaping (FairyIcon) -> Void) {
		self.onTapped = action
	}
	
	@objc private func onTappedCall() {
		self.onTapped?(self)
	}
	
}

extension FairyIcon {
	
	func signalStrengthDidChange() {
		
		let alpha = CGFloat(self.signalStrength)
		self.alpha = alpha
		
	}
	
}

extension FairyIcon {
	
	func appear() {
		
		self.alpha = 0
		self.danbo.transform { $0
			.scaleBy(dy: 0.1)
			.commit()
		}
		
		UIView.animate(withDuration: 0.3) { 
			self.alpha = 1
			self.danbo.transform{ $0
				.reset()
				.commit()
			}
		}
		
	}
	
	func disappear() {
		
		UIView.animate(withDuration: 0.3, animations: { 
			self.alpha = 0
			self.danbo.transform({ $0
				.scaleBy(dy: 0.1)
				.commit()
			})
		}, completion: { _ in
			self.removeFromSuperview()
		})
		
	}
	
}
