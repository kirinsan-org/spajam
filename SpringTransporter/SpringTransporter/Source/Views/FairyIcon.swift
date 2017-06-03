//
//  FairyIcon.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/03.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit
import Danbo

final class FairyIcon: UIView {
	
	let name: String
	var signalStrength: Double {
		didSet {
			self.signalStrengthDidChange()
		}
	}
	
	init(name: String, signalStrength: Double) {
		
		self.name = name
		self.signalStrength = signalStrength
		
		super.init(frame: .zero)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
