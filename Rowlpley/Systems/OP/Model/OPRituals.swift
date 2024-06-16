//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI

struct OPRitual: LocalizedObject, Codable, Hashable, WithOptionalIcon {
    let id: StringId
    let icon: String?
    let circle: OPRitualCircle
    let element: OPEffect
    let costs: [Int]
}

extension OPCharacter {
    func add(ritual: OPRitual) {
        rituals.append(ritual)
    }
}

enum OPRitualCircle: Int, CaseIterable, Codable, Comparable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case sixth
    case seventh

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension OPRitualCircle {
    init(_ number: Int) throws {
        if let instance = Self(rawValue: number) {
            self = instance
        } else {
            throw UnexpectedValueError(number, 1...7)
        }
    }
}
