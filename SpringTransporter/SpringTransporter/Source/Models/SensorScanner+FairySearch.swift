//
//  SensorScanner+FairySearch.swift
//  SpringTransporter
//
//  Created by Jun Tanaka on 2017/06/04.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import Foundation

extension SensorScanner: FairySearchViewDataSource {
    func fairies(for fairySearchView: FairySearchView) -> [FairyInfo] {
        return sensors.map { sensor in
            return (name: sensor.name ?? "", signalStrength: Double(sensor.rssi))
        }
    }
}
