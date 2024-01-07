//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import Foundation
import Expressive

enum OPAttribute: Codable, CaseIterable {
    case AGI
    case FOR
    case INT
    case PRE
    case VIG
}

struct OPClass: LocalizedObject, Codable {
    let id: OPClass.Id
    let hitPoints: Expression
    let effortPoints: Expression
    let sanity: Expression
    let baseSkillsOptions: [[OPSkill]]
    let extraSkills: Expression
    let proficiencies: [OPProficiency]
    let tracks: [OPTrack]
    let powers: [OPClassPower]

    static let empty: Self = Self(id: OPClass.Id(id: .empty, system: .empty), hitPoints: 0, effortPoints: 0, sanity: 0, baseSkillsOptions: [], extraSkills: 0, proficiencies: [], tracks: [], powers: [])
    struct Id: StringIdProvider {
        let id: StringId
        let system: RPGSystemId
        var get: OPClass { system.op.byId(self) }
    }
}

struct OPClassPower: DefenseBonus, Codable {
    let id: StringId
    let defenseBonus: Expression?
    let resistances: [OPResistance]
    let statBonuses: [OPStatBonus]
    let skillBonuses: [OPSkillBonus]
    let itemBonuses: [OPItemBonus]
    let proficiencies: [OPProficiency]
}

struct OPOrigin: LocalizedObject, Codable {
    let id: OPOrigin.Id
    let power: OPOriginPower
    let baseSkills: [OPSkill]
    let extraSkills: Int

    static let empty: Self = Self(id: OPOrigin.Id(id: .empty, system: .empty), power: .empty, baseSkills: [], extraSkills: 0)
    struct Id: StringIdProvider {
        let id: StringId
        let system: RPGSystemId
        var get: OPOrigin { system.op.byId(self) }
    }
}

struct OPOriginPower: LocalizedObject, Codable {
    let id: StringId

    static let empty: Self = Self(id: .empty)
}

struct OPTrack: LocalizedObject, Codable {
    let id: OPTrack.Id
    let powers: [OPTrackPower]

    static let empty: Self = Self(id: OPTrack.Id(id: .empty, system: .empty), powers: [])
    struct Id: StringIdProvider {
        let id: StringId
        let system: RPGSystemId
        var get: OPTrack { system.op.byId(self) }
    }
}

struct OPTrackPower: LocalizedObject, Codable {
    let id: StringId
    let nex: OPNex
    let defenseBonus: Expression?
    let resistances: [OPResistance]
    let statBonuses: [OPStatBonus]
    let skillBonuses: [OPSkillBonus]
    let itemBonuses: [OPItemBonus]
    let proficiencies: [OPProficiency]
}

enum OPStat: Codable, CaseIterable {
    case hitPoints
    case effortPoints
    case sanity
    case movement
    case load
    case rituals
}

enum OPSkill: Codable, CaseIterable {
    case acrobatics
    case animals
    case arts
    case athletics
    case worldliness
    case sciences
    case crime
    case diplomacy
    case deceiving
    case fortitude
    case stealth
    case initiative
    case intimidation
    case intuition
    case investigation
    case melee
    case medicine
    case occultism
    case perception
    case steering
    case marksmanship
    case profession
    case reflexes
    case religion
    case survival
    case tactics
    case technology
    case will
}

enum OPElement {
    case red
    case black
    case purple
    case gold
    case white
    case empty
}

enum OPStrike: Codable, CaseIterable {
    case red
    case black
    case purple
    case gold
    case white
    case empty

    case mental

    case chemical
    case cold
    case fire

    case impact
    case piercing
    case cutting
    case ballistic
}

extension OPStrike {
    static let weapon:     Set<Self> = [.impact, .piercing, .cutting, .ballistic]
    static let effect:     Set<Self> = [.chemical, .cold, .fire]
    static let physical:   Set<Self> = OPStrike.weapon + OPStrike.effect
    static let paranormal: Set<Self> = [.red, .black, .purple, .gold, .white, .empty]
}

enum OPProficiencyTag: Codable, CaseIterable {
    case weapons
    case armors

    case light

    case melee
    case fire
    case shooting

    case simple
    case tactical
    case heavy

    case oneHanded
    case twoHanded
}

extension OPProficiencyTag {
    static let weights: Set<Self> = [.light, .heavy]
}

extension OPProficiencyTag {
    static let levels:  Set<Self> = [.simple, .tactical, .heavy]
    static let ranges:  Set<Self> = [.melee, .fire, .shooting]
    static let hands:   Set<Self> = [.oneHanded, .twoHanded]
}

struct OPProficiency: LocalizedObject, Codable, Equatable {
    let id: StringId
    let tags: Set<OPProficiencyTag>

    init(id: StringId) throws {
        self.id = id
        self.tags = Set(try id.content.components(separatedBy: " ").map {
            try OPProficiencyTag($0)
        })
    }
}

struct OPAttributeBonus: Codable {
    let attribute: OPAttribute
    let modifier: RPGModifier
}

struct OPResistance: Codable {
    let strike: OPStrike
    let modifier: RPGModifier
}

struct OPStatBonus: Codable {
    let stat: OPStat
    let modifier: RPGModifier
}

struct OPItemBonus: Codable {
    let proficiency: OPProficiency
    let modifier: RPGModifier
}

struct OPSkillBonus: Codable {
    let skill: OPSkill
    let modifier: RPGModifier
}

extension RPGBonus {
    func opResistance() throws -> OPResistance {
        OPResistance(
            strike: try OPStrike(target),
            modifier: modifier
        )
    }

    func opStatBonus() throws -> OPStatBonus {
        OPStatBonus(
            stat: try OPStat(target),
            modifier: modifier
        )
    }

    func opSkillBonus() throws -> OPSkillBonus {
        OPSkillBonus(
            skill: try OPSkill(target),
            modifier: modifier
        )
    }

    func opItemBonus() throws -> OPItemBonus {
        OPItemBonus(
            proficiency: try OPProficiency(id: target.stringId()),
            modifier: modifier
        )
    }
}

