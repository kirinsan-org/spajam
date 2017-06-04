//
//  SeasonCharacter.swift
//  SpringTransporter
//
//  Created by Jun Tanaka on 2017/06/04.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import Foundation

enum SeasonType: String {
    case spring = "spring"
    case summer = "summer"
    case autumn = "autumn"
    case winter = "winter"
}

enum SeasonCharacterState: Int {
    case born = 0
    case live = 1
    case dead = 2
}

struct SeasonCharacter {
    var type: SeasonType
    var state: SeasonCharacterState
    var pain: Int
    var emotion: String
}
