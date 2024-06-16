//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import Expressive

protocol DefenseBonus: LocalizedObject {
    var defenseBonus: Expression? { get }
}

protocol Equipable: DefenseBonus {
    var load: Int { get }
    var category: Int { get }
}

enum Modification: Codable {
    case antibomb
    case shielded
    case discreet
    case reinforced

    case dangerous

    case improved
}

protocol ModifiableItem: Equipable {
    var modifications: [Modification] { get }
}

extension ModifiableItem {
    func nameWithModifiers(_ system: RPGSystem) -> String {
        name(system)
    }
}

struct OPWeapon: ModifiableItem, Codable, Hashable {
    let id: StringId
    let icon: String?
    let load: Int
    let category: Int
    let defenseBonus: Expression?
    let modifications: [Modification]
    let level: OPProficiencyTag
    let range: OPProficiencyTag
    let handedness: OPProficiencyTag
    let hits: [OPHit]
}

struct OPProtection: ModifiableItem, Codable, Hashable {
    let id: StringId
    let icon: String?
    let load: Int
    let category: Int
    let defenseBonus: Expression?
    let modifications: [Modification]
    let weight: OPProficiencyTag
}

struct OPItem: DefenseBonus, Codable, Hashable {
    let id: StringId
    let icon: String?
    let load: Int
    let category: Int
    let defenseBonus: Expression?
    let domain: StringId
}

struct OPAmmunition: LocalizedObject, Codable {
    let id: StringId
}

extension OPCharacter {
    func add(weapon: OPWeapon) {
        weapons.append(weapon)
    }
}

extension OPCharacter {
    func add(protection: OPProtection) {
        protections.append(protection)
    }
}

extension OPCharacter {
    func add(item: OPItem) {
        items.append(item)
    }
}
