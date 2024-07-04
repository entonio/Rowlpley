//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import Expressive
import Tabular

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

enum OPEffect: Codable, CaseIterable, Hashable, Comparable {
    case red
    case black
    case purple
    case gold
    case white
    case blue

    case mental

    case chemical
    case cold
    case fire

    case impact
    case piercing
    case cutting
    case ballistic
}

extension Set<OPEffect> {
    static let paranormal: Self = [.red, .black, .purple, .gold, .white, .blue]
    static let reactive:   Self = [.chemical, .cold, .fire]
    static let mechanical: Self = [.impact, .piercing, .cutting, .ballistic]
    static let physical:   Self = .mechanical + .reactive
}

extension Set<OPEffect> {
    static let elements:   Self = .paranormal
}

enum OPProficiencyTag: Codable, CaseIterable, Comparable {
    case weapons
    case protections

    case light

    case simple
    case tactical
    case heavy

    case melee
    case shooting
    case fire

    case oneHanded
    case twoHanded
}

extension Set<OPProficiencyTag> {
    static let basics:         Self = [.light, .simple, .oneHanded]
}

extension Set<OPProficiencyTag> {
    static let weights:        Self = [.light, .heavy]
}

extension Set<OPProficiencyTag> {
    static let levels:         Self = [.simple, .tactical, .heavy]
    static let ranges:         Self = [.melee, .shooting, .fire]
    static let handednesses:   Self = [.oneHanded, .twoHanded]
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
    let type: OPEffect
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
            type: try OPEffect(target),
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

struct OPHit: Codable, Hashable {
    let type: OPEffect
    let modifier: RPGModifier
}

extension RPGHit {
    func opHit() throws -> OPHit {
        OPHit(
            type: try OPEffect(type),
            modifier: modifier
        )
    }
}

struct OPCriticalHit: Codable, Hashable {
    let difficulty: Int
    let multiplier: Int
}

extension OPCriticalHit {
    static let `default` = Self(difficulty: 20, multiplier: 2)
}

extension OPCriticalHit {
    init?(_ string: String) throws {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.isEmpty {
            return nil
        }
        guard let match = string.wholeMatch(of: /.*?(\d\d+)?[\/,\.\s-]*(?:[xX]\s*(\d+))?/)?.output else {
            throw UnusableValueError(string, for: Self.self)
        }
        if let d = match.1, let d = Int(d) {
            if d =~ 1...20 {
                self.difficulty = d
            } else {
                throw UnusableValueError(d, for: "difficulty: 1...20")
            }
        } else {
            self.difficulty = Self.default.difficulty
        }
        if let m = match.2, let m = Int(m) {
            if m > 1 {
                self.multiplier = m
            } else {
                throw UnusableValueError(m, for: "multiplier: > 1")
            }
        } else {
            self.multiplier = Self.default.multiplier
        }
    }
}
