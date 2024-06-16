//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import Expressive
import SwiftUI

protocol DefenseBonus: LocalizedObject {
    var defenseBonus: Expression? { get }
}

protocol Equipable: DefenseBonus {
    var load: Int { get }
    var category: OPItemCategory { get }
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
    let category: OPItemCategory
    let defenseBonus: Expression?
    let modifications: [Modification]
    let level: OPProficiencyTag
    let range: OPProficiencyTag
    let handedness: OPProficiencyTag
    let hits: [OPHit]
}

struct OPProtection: ModifiableItem, Codable, Hashable, WithOptionalIcon {
    let id: StringId
    let icon: String?
    let load: Int
    let category: OPItemCategory
    let defenseBonus: Expression?
    let modifications: [Modification]
    let weight: OPProficiencyTag
}

struct OPItem: DefenseBonus, Codable, Hashable, WithOptionalIcon {
    let id: StringId
    let icon: String?
    let load: Int
    let category: OPItemCategory
    let defenseBonus: Expression?
    let domain: OPItemDomain
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

enum OPItemDomain: Codable, CaseIterable, Comparable {
    case medicine
    case profession
    case documents
}

enum OPItemCategory: Int, Codable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
}

extension OPItemCategory {
    init(_ number: Int) throws {
        if let i = Self(rawValue: number) {
            self = i
        } else {
            throw UnexpectedValueError(number, 1...5)
        }
    }
}
