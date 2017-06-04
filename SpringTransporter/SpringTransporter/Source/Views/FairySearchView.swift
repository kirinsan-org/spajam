//
//  FairySearchView.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/03.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit
import NotAutoLayout
import Eltaso

protocol FairySearchViewDataSource: class {
	typealias FairyInfo = (name: String, signalStrength: Double)
	func fairies(for fairySearchView: FairySearchView) -> [FairyInfo]
}

final class FairySearchView: LayoutView {
	
	weak var dataSource: FairySearchViewDataSource?
	
	fileprivate var onFairyIconTapped: ((FairyIcon) -> Void)?
	
	typealias FairyCache = [String: FairyIcon]
	fileprivate(set) var loadedFaries: FairyCache = [:]
	
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
		self.backgroundColor = .yellow
	}
	
}

extension FairySearchView {
	
	func setOnFairyTappedAction(_ action: @escaping (FairyIcon) -> Void) {
		self.onFairyIconTapped = action
	}
	
}

extension FairySearchView {
	
	private func makeRandomPoint() -> CGPoint {
		
		let point = CGPoint(x: .createRandom(within: 0.2 ... 0.8),
		                    y: .createRandom(within: 0.2 ... 0.8))
		return point
		
	}
	
	private func makeLayout(at relativePoint: CGPoint) -> Layout {
		
		let layout = Layout.makeCustom { (boundSize) -> Frame in
			let x = boundSize.width * relativePoint.x
			let y = boundSize.height * relativePoint.y
			let frame = Frame(x: x, from: .left,
			                  y: y, from: .top,
			                  width: 64,
			                  height: 64)
			return frame
		}
		
		return layout
		
	}
	
	private func addFairy(name: String, signalStrength: Double) {
		
		let randomPoint = self.makeRandomPoint()
		let iconLayout = self.makeLayout(at: randomPoint)
		let fairyIcon = FairyIcon(name: name, signalStrength: signalStrength)
		self.loadedFaries[name] = fairyIcon
		self.addSubview(fairyIcon, constantLayout: iconLayout)
		fairyIcon.setOnTappedAction { [unowned self] (fairy) in self.onFairyIconTapped?(fairy) }
		fairyIcon.appear()
		
	}
	
	func updateFairies() {
		
		guard let fairies = self.dataSource?.fairies(for: self) else {
			return
		}
		
		for fairy in fairies {
			if let fairyIcon = self.loadedFaries[fairy.name] {
				fairyIcon.signalStrength = fairy.signalStrength
				
			} else {
				self.addFairy(name: fairy.name, signalStrength: fairy.signalStrength)
				
			}
		}
		
		for fairy in self.subviews.flatten(in: FairyIcon.self) {
			if !fairies.contains(name: fairy.name) {
				self.loadedFaries[fairy.name] = nil
				fairy.disappear()
			}
		}
		
	}
	
}

private extension Array where Element == FairySearchViewDataSource.FairyInfo {
	
	func contains(name: String) -> Bool {
		return self.contains(where: { (comparingName, _) -> Bool in
			return name == comparingName
		})
	}
	
}
