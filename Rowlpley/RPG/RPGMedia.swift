//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

struct RPGMedia {
    private static let dndPictures: [String] = [
    ]

    private static let opPictures = (1...6).map {
        "opCharacter\($0)"
    }

    static func picture(_ type: RPGSystemType, characterNames: [String]) -> String {
        switch type {
        case .DnD5:  Self.dndPictures.element(modulo: characterNames.first!.stableHash)
        case .OP: /[aeiyl]$/.ignoresCase().test(characterNames.first!)
            ? Self.opPictures.every(1, of: 2).element(modulo: characterNames.joined(separator: " ").stableHash)
            : Self.opPictures.every(2, of: 2).element(modulo: characterNames.joined(separator: " ").stableHash)
        }
    }
}
