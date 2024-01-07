//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

struct RPGNames {
    private init() {}

    private static let fantasyNames = [
        "",           "",         "",           "Dior",        "",
        "",           "",         "",           "",            "",
        "",           "",         "",           "",            "",
        "",           "",         "Xanthique",  "",            "Zigil"
    ].filter{ $0.hasContents }

    private static let fantasySurnames = [
        "",           "",         "",           "",            "",
        "",           "",         "",           "",            "",
        "",           "",         "",           "",            "",
        "",           "",         "",           "",            "Zirak"
    ].filter{ $0.hasContents }

    private static let modernNames = [
        "Alsbeth",    "Boris",    "Carlos",     "Dae",         "Eli",
        "Ford",       "Gundagun", "Jessie",     "Ludmilla",    "Molib",
        "Nani",       "Oscar",    "Park",       "Rael",        "Samantha",
        "Tulaq",      "Viola",    "Xha",        "Yael",        "Zoe"
    ].filter{ $0.hasContents }

    private static let modernSurnames = [
        "Alcafiades", "Bananas",  "Caramanlis", "Dewi",        "Eli",
        "Finisterre", "Gesufino", "Jonlan",     "Lopes",       "Mastroiani",
        "Nidrantal",  "Ocarina",  "Prefect",    "Rongo-rongo", "Stein",
        "Tupinambur", "Venkman",  "Xis",        "Yerivaldo",   "Zea"
    ]

    static func randomName(_ type: RPGSystemType) -> [String] {
        switch type {
        case .DnD5: [
            Self.fantasyNames.randomElement()!,
            Self.fantasySurnames.randomElement()!
        ]
        case .OP: [
            Self.modernNames.randomElement()!,
            Self.modernSurnames.randomElement()!
        ]
        }
    }
}
