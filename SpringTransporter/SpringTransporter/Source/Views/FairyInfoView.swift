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
    func pixleName(for fairyInfoView: FairyInfoView) -> String?
	func pixieStatus(for fairyInfoView: FairyInfoView) -> (season: FairyInfoView.Season, phase: Int)
	func pixieEmotion(for fairyInfoView: FairyInfoView) -> FairyInfoView.Emotion?
}

class FairyInfoView: UIView {
	
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

    var webView = UIWebView()
	
	weak var dataSource: FairyInfoViewDataSource?

    func reload() {
        guard let dataSource = self.dataSource else {
            return
        }

        let name = dataSource.pixleName(for: self)
        let status = dataSource.pixieStatus(for: self)
        let emotion = dataSource.pixieEmotion(for: self)

        setPixieStatus(season: status.season.rawValue, phase: status.phase)
        setPixieEmotion(emotion)
        setPixie(name: name, old: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(webView)
        webView.delegate = self
        webView.frame = bounds
    }
}

extension FairyInfoView: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async { [weak self] in
            self?.reload()
        }
    }
}

extension FairyInfoView {
	func setPixieStatus(season: String, phase: Int) {
		guard let status = self.dataSource?.pixieStatus(for: self) else {
			return
		}
		let script = "setPixieStatus( season?:\(status.season.rawValue) , phase:\(status.phase) )"
		webView.stringByEvaluatingJavaScript(from: script)
	}
	
	func setPixieEmotion(_ emotion: Emotion?) {
		guard let emotion = self.dataSource?.pixieEmotion(for: self) else {
			return
		}
		let script = "setPixieEmotion( \(emotion.rawValue) )"
		webView.stringByEvaluatingJavaScript(from: script)
	}
	
	func setPixie(name: String?, old: Int?) {
		let script = "setPixieName(\"\(name ?? "")\" , \(String(describing: old)))"
		webView.stringByEvaluatingJavaScript(from: script)
	}
}
