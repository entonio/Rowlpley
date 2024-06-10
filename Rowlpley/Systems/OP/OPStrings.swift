//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI

extension OPAttribute {
    var label: LocalizedStringKey {
        switch self {
        case .AGI: "AGI"
        case .FOR: "FOR"
        case .INT: "INT"
        case .PRE: "PRE"
        case .VIG: "VIG"
        }
    }
}

extension OPStat: LocalizedEnum {
    var name: LocalizedStringKey {
        switch self {
        case .hitPoints:    "Hit Points"
        case .effortPoints: "Effort Points"
        case .sanity:       "Sanity"
        case .rituals:      "Rituals"
        case .movement:     "Movement"
        case .load:         "Load"
        }
    }
}

extension OPStrike: LocalizedEnum {
    var name: LocalizedStringKey {
        switch self {
        case .red:       "Red"
        case .black:     "Black"
        case .purple:    "Purple"
        case .gold:      "Gold"
        case .white:     "White"
        case .empty:     "Empty"
        case .mental:    "Mental"
        case .chemical:  "Chemical"
        case .cold:      "Cold"
        case .fire:      "Fire"
        case .impact:    "Impact"
        case .piercing:  "Piercing"
        case .cutting:   "Cutting"
        case .ballistic: "Ballistic"
        }
    }
}

extension OPSkill: LocalizedEnum {
    var name: LocalizedStringKey {
        switch self {
        case .acrobatics:    "Acrobatics"
        case .animals:       "Animals"
        case .arts:          "Arts"
        case .athletics:     "Athletics"
        case .worldliness:   "Worldliness"
        case .sciences:      "Sciences"
        case .crime:         "Crime"
        case .diplomacy:     "Diplomacy"
        case .deceiving:     "Deceiving"
        case .fortitude:     "Fortitude"
        case .stealth:       "Stealth"
        case .initiative:    "Initiative"
        case .intimidation:  "Intimidation"
        case .intuition:     "Intuition"
        case .investigation: "Investigation"
        case .melee:         "Melee"
        case .medicine:      "Medicine"
        case .occultism:     "Occultism"
        case .perception:    "Perception"
        case .steering:      "Steering"
        case .marksmanship:  "Marksmanship"
        case .profession:    "Profession"
        case .reflexes:      "Reflexes"
        case .religion:      "Religion"
        case .survival:      "Survival"
        case .tactics:       "Tactics"
        case .technology:    "Technology"
        case .will:          "Will"
        }
    }
}

extension OPProficiencyTag: LocalizedEnum {
    var name: LocalizedStringKey {
        switch self {
        case .weapons:      "Weapons"
        case .protections:  "Protections"
        case .light:        "Light"
        case .heavy:        "Heavy"
        case .melee:        "Melee"
        case .fire:         "Fire"
        case .shooting:     "Shooting"
        case .tactical:     "Tactical"
        case .simple:       "Simple"
        case .oneHanded:    "One-handed"
        case .twoHanded:    "Two-handed"
        }
    }
}
