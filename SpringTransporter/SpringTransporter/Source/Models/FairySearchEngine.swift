//
//  FairySearchEngine.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import Foundation

class FairySearchEngine {
	
	
	
}

class DummyFairySearchEngine: FairySearchEngine {
	
	
	
}

extension DummyFairySearchEngine: FairySearchViewDataSource {
	
	func fairies(for fairySearchView: FairySearchView) -> [FairySearchViewDataSource.FairyInfo] {
		
		let info = (name: "test", signalStrength: 0.75)
		return [info]
		
	}
	
}

extension DummyFairySearchEngine: FairyInfoViewDataSource {
	
}
