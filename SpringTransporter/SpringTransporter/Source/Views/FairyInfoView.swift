//
//  FairyInfoView.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit
import WebKit
import NotAutoLayout

protocol FairyInfoViewDataSource: class {
	func pixieStatus(for fairyInfoView: FairyInfoView) -> (season: FairyInfoView.Season, phase: Int)
	func pixieEmotion(for fairyInfoView: FairyInfoView) -> FairyInfoView.Emotion
}

class FairyInfoView: UIWebView {
	
	enum Season: String {
		case spring
		case summer
		case autumn
		case winter
		case none
	}
	
	enum Emotion: String {
		case shake
		case hurt
		case happy
	}
	
	weak var dataSource: FairyInfoViewDataSource?
	
}

extension FairyInfoView {
	
	func test() {
//		let script = "alert(window.setPixieStatus)"
//		print(self.stringByEvaluatingJavaScript(from: script) as Any)
	}
	
}

extension FairyInfoView {
	
	func setPixieStatus(season: String, phase: Int) {
		guard let status = self.dataSource?.pixieStatus(for: self) else {
			return
		}
		let script = "setPixieStatus( season?:\(status.season.rawValue) , phase:\(status.phase) )"
		self.stringByEvaluatingJavaScript(from: script)
	}
	
	func setPixieEmotion(_ emotion: Emotion) {
		guard let emotion = self.dataSource?.pixieEmotion(for: self) else {
			return
		}
		let script = "setPixieEmotion( \(emotion.rawValue) )"
		self.stringByEvaluatingJavaScript(from: script)
	}
	
	func setPixie(name: String?, old: Int?) {
		let script = "setPixieName(name?:\"\(name)\" , old?:\(String(describing: old)))"
		self.stringByEvaluatingJavaScript(from: script)
	}
	
}
