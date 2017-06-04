//
//  SensorScanner.swift
//  SpringTransporter
//
//  Created by Jun Tanaka on 2017/06/04.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import FirebaseDatabase
import ALPS

private let watchingPeripheralUUIDs: [UUID] = [
    UUID(uuidString: "65EDEF7D-E622-4C77-B9AB-C4D6170DA116")!
]

protocol SensorScannerDelegate: class {
    func sensorScanner(_ sensorScanner: SensorScanner, didFind sensor: Sensor)
    func sensorScanner(_ sensorScanner: SensorScanner, didLost sensor: Sensor)
}

final class SensorScanner {
    fileprivate let alpsManager = ALPS.Manager()
    fileprivate let sensorsRef: FIRDatabaseReference = FIRDatabase.database().reference(withPath: "sensor")

    fileprivate(set) var sensors: [Sensor] = []

    weak var delegate: SensorScannerDelegate?

    static let shared = SensorScanner()

    init() {
        alpsManager.delegate = self
    }

    func start() {
        alpsManager.startScan()
        print("started scanning")
    }

    func stop() {
        alpsManager.stopScan()
        print("stopped scanning")
    }

    fileprivate func sensor(for peripheral: ALPS.Peripheral) -> Sensor? {
        return sensors.first(where: { $0.uuid == peripheral.uuid })
    }
}

extension SensorScanner: ALPS.ManagerDelegate {
    public func manager(_ manager: ALPS.Manager, didDiscover peripheral: ALPS.Peripheral) {
        guard watchingPeripheralUUIDs.contains(peripheral.uuid) else {
            return
        }

        let sensor = Sensor(peripheral: peripheral)
        sensors.append(sensor)

        manager.connect(peripheral)
    }

    public func manager(_ manager: ALPS.Manager, didConnect peripheral: ALPS.Peripheral) {
        guard let index = sensors.index(where: { $0.uuid == peripheral.uuid }) else {
            return
        }

        let sensor = sensors[index]

        delegate?.sensorScanner(self, didFind: sensor)
    }

    public func manager(_ manager: ALPS.Manager, didDisconnect peripheral: ALPS.Peripheral) {
        guard let index = sensors.index(where: { $0.uuid == peripheral.uuid }) else {
            return
        }

        let sensor = sensors[index]
        sensors.remove(at: index)

        delegate?.sensorScanner(self, didLost: sensor)
    }
}
