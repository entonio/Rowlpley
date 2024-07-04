//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct Localizations {
    private var map: [Locale.LanguageCode: [String: String]] = [:]
    
    mutating func set(_ language: Locale.LanguageCode, _ key: String, _ value: String) {
        var strings = map[language] ?? [:]
        strings[key] = value
        map[language] = strings
    }

    func get(_ key: String) -> String {
        get(language: Locale.current.language.languageCode!, key)
    }

    func get(language: Locale.LanguageCode, _ key: String) -> String {
        map[language]?[key] ?? key
    }
}

protocol LocalizedObject: Identifiable where ID: StringIdProvider {
    var id: ID { get }
}

extension LocalizedObject {
    func name(_ system: RPGSystem) -> String { id.id.dynLoc(system) }
}

protocol LocalizedEnum: CaseIterable, Identifiable {
    var name: LocalizedStringKey { get }
}

extension LocalizedEnum {
    // if .key becomes unavailable, use String(describing:name), all that matters is that it's unique, not the value
    var id: StringId { name.key.stringId() }
}

extension LocalizedEnum {
    init(_ name: String, _ cases: (any Collection<Self>)? = nil) throws {
        let name = name.lowercased()
        let result = (cases ?? Self.allCases).first {
            // if .key becomes unavailable, use
            // $0.name == LocalizedStringKey(stringLiteral: name)
            $0.name.key.lowercased() == name
        }
        guard let result else {
            if let cases {
                throw ConversionError(name, cases)
            } else {
                throw ConversionError(name, Self.self)
            }
        }
        self = result
    }
}

extension LocalizedStringKey {
    var key: String {
        Mirror(reflecting: self)
            .children
            .first { $0.label == "key" }!
            .value as! String
    }
}

extension LocalizedStringKey {
    func localized(tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        self.key.localized(tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
}

extension String {
    var initial: Character {
        first!
    }

    var capital: String {
        initial.uppercased()
    }
}

extension String {
    func localized(tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
}
