//
//  Sensor.swift
//  SpringTransporter
//
//  Created by Jun Tanaka on 2017/06/04.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import ALPS
import FirebaseDatabase

protocol SensorDelegate: class {
    func sensor(_ sensor: Sensor, didUpdate character: SeasonCharacter)
}

final class Sensor {
    fileprivate let peripheral: ALPS.Peripheral
    fileprivate let sensorDatabaseRef: FIRDatabaseReference
    fileprivate let seasonDatabaseRef: FIRDatabaseReference
    fileprivate var seasonDatabaseObservingHandle: UInt!

    var uuid: UUID {
        return peripheral.uuid
    }

    var name: String? {
        return peripheral.name
    }

    var rssi: Int {
        return peripheral.rssi
    }

    weak var delegate: SensorDelegate?

    init(peripheral: ALPS.Peripheral) {
        let database = FIRDatabase.database()
        let sensorDatabaseRef = database.reference(withPath: "sensor/\(peripheral.uuid.uuidString)")
        let seasonDatabaseRef = database.reference(withPath: "season/\(peripheral.uuid.uuidString)")

        self.peripheral = peripheral
        self.sensorDatabaseRef = sensorDatabaseRef
        self.seasonDatabaseRef = seasonDatabaseRef

        self.seasonDatabaseObservingHandle = seasonDatabaseRef.observe(.value, with: { [weak self] snapshot in
            guard
                snapshot.exists(),
                let rawType = snapshot.childSnapshot(forPath: "type").value as? String,
                let rawState = snapshot.childSnapshot(forPath: "state").value as? Int,
                let pain = snapshot.childSnapshot(forPath: "pain").value as? Int,
                let type = SeasonType(rawValue: rawType),
                let state = SeasonCharacterState(rawValue: rawState),
                let strongSelf = self
            else {
                return
            }

            let character = SeasonCharacter(
                type: type,
                state: state,
                pain: pain
            )

            strongSelf.delegate?.sensor(strongSelf, didUpdate: character)
        })

        peripheral.delegate = self
    }

    deinit {
        seasonDatabaseRef.removeObserver(withHandle: seasonDatabaseObservingHandle)
    }
}

extension Sensor: ALPS.PeripheralDelegate {
    public func peripheral(_ peripheral: ALPS.Peripheral, didUpdateSensor parameters: [ALPS.SensorParameter]) {
        var dictionary: [String : Any] = [:]

        parameters.forEach { parameter in
            dictionary[parameter.key.rawValue] = parameter.value
        }

        sensorDatabaseRef.updateChildValues(dictionary)
    }
}
