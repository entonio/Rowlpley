//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

struct DeSerializer {
    func serializedCharacters(_ characters: [any RPGCharacter]) -> [RowlPC] {
        characters.map {
            RowlPC(
                name: "\($0.system.id.content)-\($0.name)-\(DateFormatter(.filenameShort).string(for: Date.now)!).json",
                text: $0.json(.prettyPrinted)
            )
        }
    }

    func deserializedCharacters(_ urls: [URL]) -> [(url: URL, character: (any RPGCharacter)?)] {
        urls.map { url in
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }

                if let data = try? Data(contentsOf: url) {
                    if let character = try? JSONDecoder().decode(DnD5Character.self, from: data), character.system.typeIs(.DnD5) {
                        character.id = UUID()
                        return (url, character)
                    }
                    if let character = try? JSONDecoder().decode(OPCharacter.self, from: data), character.system.typeIs(.OP) {
                        character.id = UUID()
                        return (url, character)
                    }
                }
            }
            return (url, nil)
        }
    }
}
