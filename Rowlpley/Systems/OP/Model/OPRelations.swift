//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

extension OPSkill {
    var attribute: OPAttribute {
        switch self {
        case .acrobatics:    .AGI
        case .animals:       .PRE
        case .arts:          .PRE
        case .athletics:     .FOR
        case .worldliness:   .INT
        case .sciences:      .INT
        case .crime:         .AGI
        case .diplomacy:     .PRE
        case .deceiving:     .PRE
        case .fortitude:     .VIG
        case .stealth:       .AGI
        case .initiative:    .AGI
        case .intimidation:  .PRE
        case .intuition:     .PRE
        case .investigation: .INT
        case .melee:         .FOR
        case .medicine:      .INT
        case .occultism:     .INT
        case .perception:    .PRE
        case .marksmanship:  .AGI
        case .profession:    .INT
        case .reflexes:      .AGI
        case .religion:      .PRE
        case .steering:      .AGI
        case .survival:      .INT
        case .tactics:       .INT
        case .technology:    .INT
        case .will:          .PRE
        }
    }
}
