//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftData
import SwiftUI
import UIKit
import Expressive

enum RPGSystemType: Codable, CaseIterable {
    case DnD5
    case OP
}

protocol RPGSystem: WithIcon {
    var id: RPGSystemId { get }
    var type: RPGSystemType { get }
    var name: String { get }
    var dynLocs: Localizations { get }
}

struct RPGSystemId: StringIdProvider {
    let id: StringId
    var get: RPGSystem { Self.byId(self) }

    static func byId(_ id: Self) -> RPGSystem { map[id]! }
    static var map: [Self: RPGSystem] = [:]
    static var systems: [RPGSystem] { map.values.map { $0 } }

    static let empty = Self(id: .empty)
}

extension RPGSystemId {
    func typeIs(_ type: RPGSystemType) -> Bool { self.get.type == type }
}

extension StringId {
    func dynLoc(_ system: RPGSystem) -> String {
        system.dynLocs.get(content)
    }
}

protocol RPGCharacter: Positionable, Equatable, Hashable, Identifiable, Codable {
    var system: RPGSystemId { get }
    var id: UUID { get }
    var names: [String] { get }
    var player: String { get }
    var icon: StorableImage? { get }
}

extension RPGCharacter {
    func json(_ format: JSONEncoder.OutputFormatting) -> String {
        try! JSONEncoder().encode(self, format: format)
    }
}

extension RPGCharacter {
    var name: String {
        names.joined(separator: " ")
    }
}

struct RPGBonus {
    let target: String
    let modifier: RPGModifier
}

extension RPGBonus {
    init?(_ string: String) throws {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.isEmpty {
            return nil
        }
        guard let match = string.wholeMatch(of: /(.+)\s+([^\s]+)/)?.output else {
            throw UnusableValueError(string, for: Self.self)
        }
        let modifier = try RPGModifier(String(match.2))
        guard let modifier else {
            throw UnusableValueError(string, for: Self.self)
        }
        self.target = String(match.1)
        self.modifier = modifier
    }
}

struct RPGModifier: Codable, Hashable {
    let formula: Expression?
    let dice: [RPGDice]?

    init(formula: Expression?, dice: [RPGDice]?) {
        self.formula = formula
        self.dice = Dictionary(grouping: dice ?? []) {
            $0.sides
        }.reduce(into: [RPGDice]()) {
            let amount = $1.value.reduce(0) { $0 + $1.amount }
            if amount != 0 {
                $0.append(RPGDice(
                    amount: amount,
                    sides: $1.key
                ))
            }
        }.nilIfEmpty
    }
}

enum DescriptionStyle {
    case simple
    case full
}

extension CustomStringConvertible {
    var expression: Expression {
        .variable(description)
    }
}

extension RPGModifier {
    var expression: Expression {
        if let dice, dice.hasContents {
            let dice = dice.map(\.expression).joined(.plus)!
            if let formula {
                return dice + formula
            } else {
                return dice
            }
        } else {
            return formula!
        }
    }
}

extension RPGModifier {
    init?(_ string: String) throws {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.isEmpty {
            return nil
        }
        if let match = string.wholeMatch(of: /([+-]?)\s*(\d+)[dD](\d*)(.*)/)?.output {
            self.dice = [RPGDice(
                amount: Int(match.1+match.2)!,
                sides: Int(match.3)
            )]
            if match.4.isEmpty {
                self.formula = nil
            } else {
                self.formula = try Expression(stringExpression: String(match.4))
            }
        } else {
            self.dice = nil
            self.formula = try Expression(stringExpression: string)
        }
    }
}

extension RPGModifier {
    func int() -> Int? {
        dice != nil ? nil : formula?.solve().int()
    }
}

extension RPGModifier: CustomStringConvertible {
    var description: String {
        if let dice {
            if let formula {
                return "\(dice) \(formula)"
            }
            return dice.description
        }
        if let formula {
            return formula.description
        }
        return ""
    }
}

extension RPGModifier {
    static let zero = Self(formula: nil, dice: nil)
}

extension Expression {
    public static func adding(lhs: Self?, rhs: Self?) -> Self? {
        if let lhs {
            if let rhs {
                return lhs + rhs
            }
            return lhs
        }
        return rhs
    }
}

extension RPGModifier {
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(
            formula: .adding(lhs: lhs.formula, rhs: rhs.formula),
            dice: RPGDice.combining(lhs: lhs.dice, rhs: rhs.dice)
        )
    }
}

struct RPGHit {
    let type: String
    let modifier: RPGModifier
}

extension RPGHit {
    init?(_ string: String) throws {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.isEmpty {
            return nil
        }
        guard let match = string.wholeMatch(of: /([^\s]+)\s+(.+)/)?.output else {
            throw UnusableValueError(string, for: Self.self)
        }
        let modifier = try RPGModifier(String(match.1))
        guard let modifier else {
            throw UnusableValueError(string, for: Self.self)
        }
        self.type = String(match.2)
        self.modifier = modifier
    }
}

struct RPGDice: Codable, Hashable {
    let amount: Int
    let sides: Int?
}

extension RPGDice: CustomStringConvertible {
    var description: String {
        if let sides {
            "\(amount)d\(sides)"
        } else {
            "\(amount)d"
        }
    }
}

extension RPGDice {
    public static func combining(lhs: [Self]?, rhs: [Self]?) -> [Self]? {
        if let lhs {
            if let rhs {
                return Dictionary(grouping: lhs + rhs) {
                    $0.sides
                }.reduce(into: [RPGDice]()) {
                    $0.append(RPGDice(
                        amount: $1.value.reduce(0) { $0 + $1.amount },
                        sides: $1.key
                    ))
                }
            }
            return lhs
        }
        return rhs
    }
}
