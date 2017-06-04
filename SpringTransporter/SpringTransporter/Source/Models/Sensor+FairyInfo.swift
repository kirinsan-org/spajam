//
//  Sensor+FairyInfop.swift
//  SpringTransporter
//
//  Created by Jun Tanaka on 2017/06/04.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import Foundation

extension Sensor: FairyInfoViewDataSource {
    func pixleName(for fairyInfoView: FairyInfoView) -> String? {
        return name
    }

    func pixieStatus(for fairyInfoView: FairyInfoView) -> (season: FairyInfoView.Season, phase: Int) {
        guard let character = self.seasonCharacter else {
            return (season: .none, phase: 0)
        }

        let season: FairyInfoView.Season
        let phase: Int = character.state.rawValue

        switch character.type {
        case .spring:
            season = .spring
        case .summer:
            season = .summer
        case .autumn:
            season = .autumn
        case .winter:
            season = .winter
        }

        return (season: season, phase: phase)
    }

    func pixieEmotion(for fairyInfoView: FairyInfoView) -> FairyInfoView.Emotion? {
        guard let rawEmotion = self.seasonCharacter?.emotion else {
            return nil
        }

        return FairyInfoView.Emotion(rawValue: rawEmotion)
    }
}
