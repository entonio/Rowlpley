//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//
        

import Foundation
import Expressive

let AGI: Expression = "AGI"
let FOR: Expression = "FOR"
let INT: Expression = "INT"
let PRE: Expression = "PRE"
let VIG: Expression = "VIG"

let NEX: Expression = "NEX"

let ITEMS: Expression = "ITEMS"
let OTHER: Expression = "OTHER"

struct OPNex: Codable, Hashable {
    static let allCases = (1...20).map { OPNex(level: $0) }

    let percent: Int
    var level: Int { percent >= 99 ? 20 : percent / 5 }

    init(percent: Int) {
        self.percent = percent
    }

    init(level: Int) {
        self.init(percent: level >= 20 ? 99 : level * 5 )
    }
}

extension OPNex: Comparable {
    static func < (lhs: OPNex, rhs: OPNex) -> Bool {
        lhs.percent < rhs.percent
    }
}

extension OPSystem {
    static let defense = 10 + AGI + ITEMS + OTHER
}

extension OPCharacter {
    func hitPoints(recover points: UInt) {
        hitPoints = min(hitPoints + Int(points), hitPointsMax)
    }

    func hitPoints(lose points: UInt) {
        let temporary = temporaryHitPoints - Int(points)
        if temporary >= 0 {
            temporaryHitPoints = temporary
        } else {
            temporaryHitPoints = 0
            hitPoints = max(0, hitPoints + temporary)
        }
    }
}

extension OPCharacter {
    func effortPoints(recover points: UInt) {
        effortPoints = min(effortPoints + Int(points), effortPointsMax)
    }

    func effortPoints(lose points: UInt) {
        effortPoints = max(0, effortPoints - Int(points))
    }
}

extension OPCharacter {
    func sanity(recover points: UInt) {
        sanity = min(sanity + Int(points), sanityMax)
    }

    func sanity(lose points: UInt) {
        sanity = max(0, sanity - Int(points))
    }
}

extension OPCharacter {
    var defense1: Expression {
        OPSystem.defense.replace([
            ITEMS: .joining(.plus, Array(defenseItemsMap.keys)) ?? ITEMS,
            OTHER: .joining(.plus, Array(defenseOtherMap.keys)) ?? OTHER,
        ])
    }

    var defense2: Expression {
        defense1.replace(defenseItemsMap + defenseOtherMap + [ITEMS: 0, OTHER: 0])
    }

    var defenseValue: Expression {
        defense2.solve(using: [
            AGI: attribute(.AGI)
        ])
    }

    private var defenseItems: [any ModifiableItem] {
        (items + weapons)
            .filter { $0.defenseBonus != nil }
    }

    private var defenseItemsMap: [Expression : Expression] {
        defenseItems.reduce(into: [:]) {
            let name = $1.nameWithModifiers(system.get)
            $0[Expression.variable(name)] = $1.defenseBonus!
        }
    }

    private var defenseOther: [any DefenseBonus] {
        classPowers
            .filter { $0.defenseBonus != nil }
    }

    private var defenseOtherMap: [Expression : Expression] {
        defenseOther.reduce(into: [:]) {
            let name = $1.name(system.get)
            $0[Expression.variable(name)] = $1.defenseBonus!
        }
    }
}

extension OPCharacter {
    var hitPointsMax: Int {
        classe.get.hitPoints.solve(using: [
            VIG: attribute(.VIG),
            NEX: nex.level,
        ]).exactInt()!
    }
    
    var effortPointsMax: Int {
        classe.get.effortPoints.solve(using: [
            PRE: attribute(.PRE),
            NEX: nex.level,
        ]).exactInt()!
    }
    
    var sanityMax: Int {
        classe.get.sanity.solve(using: [
            INT: attribute(.INT),
            NEX: nex.level,
        ]).exactInt()!
    }

    var baseSkills: [OPSkill] {
        classSkills + origin.get.baseSkills
    }

    var extraSkillsCount: Int {
        classe.get.extraSkills.solve(using: [
            INT: attribute(.INT),
        ]).exactInt()!
        +
        origin.get.extraSkills
    }

    var attributesBase: Int {
        5 + 4 + [20, 50, 80, 95].filter { nex.percent >= $0 }.count
    }
    
    var attributesSum: Int {
        attributes.values.reduce(0, +)
    }

    func setNex(_ nex: OPNex) {
        let base = attributesBase
        attributesTotal -= base
        self.nex = nex
        attributesTotal += attributesBase
    }
}

extension OPAttribute {
    static let range = [0, 1, 2, 3, 4, 5]
}

extension OPSkill {
    static let trained = 5
    static let training = [0, 5, 10, 15]
}

struct OPDice {
    let attribute: Int
    
    var count: Int { isDisadvantage ? 1 + (1 - attribute) : attribute }
    var isDisadvantage: Bool { attribute < 1 }
    var sign: String { isDisadvantage ? "-" : "" }
}
