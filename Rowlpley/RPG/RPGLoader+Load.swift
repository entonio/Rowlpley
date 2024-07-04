//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import Tabular
import Expressive

extension RPGLoader {
    func load() throws {
        try load(systemId: "DnD5")
        try load(systemId: "OP")
    }

    private func load(systemId: String) throws {
        let basics = try loadSystemBasics(systemId)
        try RPGSystemId.map.do { $0[basics.id] = switch basics.type {
        case .DnD5: try loadDnD5(basics)
        case .OP: try loadOP(basics)
        }}
    }

    private func loadSystemBasics(_ systemId: String) throws -> any RPGSystem {
        let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)Basics.xlsx")
        struct RPGSystemBasics: RPGSystem {
            var id: RPGSystemId
            var type: RPGSystemType
            var name: String
            var icon: String
            var dynLocs: Localizations
        }
        return try RPGSystemBasics(
            id: RPGSystemId(id: systemId.stringId()),
            type: table.at(row: "Type").rpgSystem(),
            name: table.at(row: "Name").text(),
            icon: table.at(row: "Icon").text(),
            dynLocs: (try? loadSystemLanguages(systemId)) ?? Localizations()
        )
    }

    private func loadSystemLanguages(_ systemId: String) throws -> Localizations {
        let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)Languages.xlsx")

        var locs = Localizations()
        try table.enumerateCols(includeLeft: false).forEach { col in
            if let code = try? table.at(row: 0, col: col).text() {
                let language = Locale.LanguageCode(code)
                try table.enumerateRows().forEach { row in
                    if let string = try? table.at(row: row, col: col).text() {
                        let key = try table.at(row: row, col: 0).text()
                        locs.set(language, key, string)
                    }
                }
            }
        }
        return locs
    }

    func load(table relativePath: String) throws -> Table<XLSX> {
        executionContext.delete(.table)
        executionContext.delete(.row)

        let absolutePath = try {
            let cachePath = FileManager.default.cache(path: relativePath)
            if FileManager.default.fileExists(atPath: cachePath) {
                return cachePath
            }
            if let bundlePath = Bundle.main.locate(path: relativePath) {
                return bundlePath
            }
            throw PreconditionError("Cannot find [\(relativePath)] in Bundle or in Cache")
        }()

        executionContext.put(.table, absolutePath)
        return try Table(xlsx: absolutePath)
    }
}

extension RPGSystemType {
    init(_ string: String) throws {
        self = switch string {
        case "DnD5": .DnD5
        case "OP": .OP
        default: throw NotConvertibleError(string, RPGSystemType.self)
        }
    }
}

extension Slot {
    func rpgSystem() throws -> RPGSystemType {
        try RPGSystemType(string)
    }
}

extension Slot {
    func expression() throws -> Expressive.Expression {
        try Expressive.Expression(stringExpression: string)
    }

    func stringId() throws -> StringId {
        try text().stringId()
    }
}
