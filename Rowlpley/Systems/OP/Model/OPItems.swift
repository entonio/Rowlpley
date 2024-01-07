//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import Foundation
import Expressive

protocol DefenseBonus: LocalizedObject {
    var defenseBonus: Expression? { get }
}

enum Modification: Codable {
    case antibomb
    case shielded
    case discreet
    case reinforced

    case dangerous

    case improved
}

protocol ModifiableItem: DefenseBonus {
    var modifications: [Modification] { get }
}

extension ModifiableItem {
    func nameWithModifiers(_ system: RPGSystem) -> String {
        name(system)
    }
}

struct OPItem: ModifiableItem, Codable {
    let id: StringId
    let defenseBonus: Expression?
    let modifications: [Modification]
}

struct OPWeapon: ModifiableItem, Codable {
    let id: StringId
    let defenseBonus: Expression?
    let modifications: [Modification]
}

struct OPAmmunition: LocalizedObject, Codable {
    let id: StringId
}
