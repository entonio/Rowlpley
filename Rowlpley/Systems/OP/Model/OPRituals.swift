//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI

struct OPRitual: LocalizedObject, Codable, Hashable, WithOptionalIcon {
    let id: StringId
    let icon: String?
    let circle: OPRitualCircle
    let element: OPEffect
    let extraCosts: [Int]
}

extension OPRitual {
    static let custom = OPRitual(id: "Custom", icon: nil, circle: .first, element: .white, extraCosts: [3, 5])
}

extension OPCharacter {
    func add(ritual: OPRitual) {
        rituals.append(ritual)
    }
}

enum OPRitualCircle: Int, CaseIterable, Codable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case sixth
    case seventh
}

extension OPRitualCircle: Comparable {
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

extension OPRitualCircle {
    var effortPoints: Int {
        switch self {
        case .first:   1
        case .second:  3
        case .third:   6
        case .fourth:  10
        case .fifth:   notImplemented()
        case .sixth:   notImplemented()
        case .seventh: notImplemented()
        }
    }
}
