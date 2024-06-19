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

extension OPWeapon {
    static let custom = OPWeapon(id: "", icon: nil, load: 1, category: .one, defenseBonus: nil, modifications: [], level: .simple, range: .melee, handedness: .oneHanded, hits: [OPHit(type: .impact, modifier: RPGModifier(formula: nil, dice: [RPGDice(amount: 1, sides: 6)]))])
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

extension OPProtection {
    static let custom = OPProtection(id: "", icon: nil, load: 1, category: .one, defenseBonus: nil, modifications: [], weight: .light)
}

struct OPItem: DefenseBonus, Codable, Hashable, WithOptionalIcon {
    let id: StringId
    let icon: String?
    let load: Int
    let category: OPItemCategory
    let defenseBonus: Expression?
    let domain: OPItemDomain
}

extension OPItem {
    static let custom = OPItem(id: "", icon: nil, load: 1, category: .one, defenseBonus: nil, domain: .documents)
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
    case one = 1
    case two
    case three
    case four
}

extension OPItemCategory {
    init(_ number: Int) throws {
        if let i = Self(rawValue: number) {
            self = i
        } else {
            throw UnexpectedValueError(number, 1...4)
        }
    }
}
