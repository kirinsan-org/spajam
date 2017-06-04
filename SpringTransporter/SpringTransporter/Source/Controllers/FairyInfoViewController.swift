//
//  FairyInfoViewController.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit

class FairyInfoViewController: UIViewController {
	
	private(set) lazy var fairyInfoView: FairyInfoView = {
		let view = FairyInfoView()
		return view
	}()
	
	let fairyInfoViewDataSource: FairyInfoViewDataSource
	
	init(dataSource: FairyInfoViewDataSource) {
		self.fairyInfoViewDataSource = dataSource
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		let view = self.fairyInfoView
		view.frame = UIScreen.main.bounds
		view.autoresizingMask = .flexibleSize
        view.dataSource = fairyInfoViewDataSource
		self.view = view
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupWebview()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.fairyInfoView.reload()
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.dismiss(animated: true, completion: nil)
	}
	
	private func setupWebview() {
		
		self.fairyInfoView.backgroundColor = .black
		
		let path = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "webcontent")!
		let url = URL(string: path)!
		let request = URLRequest(url: url)
		self.fairyInfoView.webView.loadRequest(request)
	}
}

extension FairyInfoViewController: SensorDelegate {
    func sensor(_ sensor: Sensor, didUpdate character: SeasonCharacter) {
        self.fairyInfoView.reload()
    }
}
