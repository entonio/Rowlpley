//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

struct OPSystem: RPGSystem {
    var type: RPGSystemType { .OP }

    let id: RPGSystemId
    let name: String
    let icon: String
    let dynLocs: Localizations

    let classes: [OPClass]
    let origins: [OPOrigin]

    let rituals: [OPRitual]
    let weapons: [OPWeapon]
    let protections: [OPProtection]
    let items: [OPItem]
    
    init(id: RPGSystemId, name: String, icon: String, dynLocs: Localizations, classes: [OPClass], origins: [OPOrigin], rituals: [OPRitual], weapons: [OPWeapon], protections: [OPProtection], items: [OPItem]) {
        self.id = id
        self.name = name
        self.icon = icon
        self.dynLocs = dynLocs

        self.classes = classes
        self.origins = origins

        self.rituals = rituals
        self.weapons = weapons
        self.protections = protections
        self.items = items

        self.mClasses = classes.map(by: \.id)
        self.mTracks = classes.flatMap(\.tracks).map(by: \.id)
        self.mOrigins = origins.map(by: \.id)
    }

    private let mClasses: [OPClass.Id: OPClass]
    private let mOrigins: [OPOrigin.Id: OPOrigin]
    private let mTracks: [OPTrack.Id: OPTrack]
    func byId(_ id: OPClass.Id) -> OPClass { mClasses[id] ?? .empty }
    func byId(_ id: OPOrigin.Id) -> OPOrigin { mOrigins[id] ?? .empty }
    func byId(_ id: OPTrack.Id) -> OPTrack { mTracks[id] ?? .empty }
}

extension RPGSystemId {
    static let OP = Self(id: "OP")
}

extension RPGSystemId {
    var op: OPSystem { self.get.op }
}

extension RPGSystem {
    var op: OPSystem { self as! OPSystem }
}

extension StringId {
    func opClass(_ system: RPGSystemId) -> OPClass.Id { OPClass.Id(id: self, system: system) }
    func opOrigin(_ system: RPGSystemId) -> OPOrigin.Id { OPOrigin.Id(id: self, system: system) }
    func opTrack(_ system: RPGSystemId) ->  OPTrack.Id { OPTrack.Id(id: self, system: system) }
}

extension RPGLoadables {
    func loadOP(_ base: any RPGSystem) throws -> OPSystem {
        let systemId = base.id.id.content

        let origins = try {
            let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)Origins.xlsx")
            return try table.enumerateRows().map { row in
                executionContext.put(.row, row)
                return try OPOrigin(
                    id: table.at(col:"ORIGIN", row).stringId().opOrigin(base.id),
                    power: OPOriginPower(id: table.at(col:"POWER", row).stringId()),
                    baseSkills: table.array(col:"SKILL", row).map {
                        try OPSkill($0.string)
                    },
                    extraSkills: table.at(col:"EXTRA SKILLS", row).int(ifEmpty: 0)
                )
            }
        }()

        let trackPowers = try {
            let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)TrackPowers.xlsx")
            return try table.enumerateRows().lazy.map { row in
                executionContext.put(.row, row)
                return (
                    classe: try table.at(col:"CLASS", row).stringId().opClass(base.id),
                    track: try table.at(col:"TRACK", row).stringId().opTrack(base.id),
                    power: try OPTrackPower(
                        id: table.at(col:"POWER", row).stringId(),
                        nex: OPNex(percent: table.at(col:"NEX", row).int()),
                        defenseBonus: try? table.at(col:"DEFENSE", row).expression(),
                        resistances: table.at(col: "RESISTANCES", row).csv().compactMap {
                            try RPGBonus($0)?.opResistance()
                        },
                        statBonuses: table.at(col: "STATS", row).csv().compactMap {
                            try RPGBonus($0)?.opStatBonus()
                        },
                        skillBonuses: table.at(col: "SKILLS", row).csv().compactMap {
                            try RPGBonus($0)?.opSkillBonus()
                        },
                        itemBonuses: table.at(col: "ITEMS", row).csv().compactMap {
                            try RPGBonus($0)?.opItemBonus()
                        },
                        proficiencies: table.at(col: "PROFICIENCIES", row).csv().compactMap {
                            $0.isEmpty ? nil : try OPProficiency(id: $0.stringId())
                        }
                    )
                )
            }.group(\.power, by: \.classe, \.track)
        }()

        let tracks = trackPowers.mapValues { byTrack in
            byTrack.keys.map { track in
                OPTrack(
                    id: track,
                    powers: byTrack[track]!
                        .sorted(using: KeyPathComparator(\.nex))
                )
            }
        }

        let classPowers = try {
            let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)ClassPowers.xlsx")
            return try table.enumerateRows().reduce(into: [OPClass.Id:[OPClassPower]]()) { byClass, row in
                executionContext.put(.row, row)
                let classe = try table.at(col:"CLASS", row).stringId().opClass(base.id)
                let power = try OPClassPower(
                    id: table.at(col:"POWER", row).stringId(),
                    defenseBonus: try? table.at(col:"DEFENSE", row).expression(),
                    resistances: table.at(col: "RESISTANCES", row).csv().compactMap {
                        try RPGBonus($0)?.opResistance()
                    },
                    statBonuses: table.at(col: "STATS", row).csv().compactMap {
                        try RPGBonus($0)?.opStatBonus()
                    },
                    skillBonuses: table.at(col: "SKILLS", row).csv().compactMap {
                        try RPGBonus($0)?.opSkillBonus()
                    },
                    itemBonuses: table.at(col: "ITEMS", row).csv().compactMap {
                        try RPGBonus($0)?.opItemBonus()
                    },
                    proficiencies: table.at(col: "PROFICIENCIES", row).csv().compactMap {
                        $0.isEmpty ? nil : try OPProficiency(id: $0.stringId())
                    }
                )

                var classPowers = byClass[classe] ?? []
                classPowers.append(power)
                byClass[classe] = classPowers
            }
        }()

        let classes = try {
            let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)Classes.xlsx")
            return try table.enumerateRows().map { row in
                executionContext.put(.row, row)
                let id = try table.at(col:"CLASS", row).stringId().opClass(base.id)
                return try OPClass(
                    id: id,
                    hitPoints: table.at(col:"HIT POINTS", row).expression(),
                    effortPoints: table.at(col:"EFFORT POINTS", row).expression(),
                    sanity: table.at(col:"SANITY", row).expression(),
                    baseSkillsOptions: table.array2(col:"SKILL", row).map {
                        try $0.map { try OPSkill($0.string) }
                    },
                    extraSkills: table.at(col:"EXTRA SKILLS", row).expression(),
                    proficiencies: table.array(col:"PROFICIENCY", row).map {
                        try OPProficiency(id: $0.stringId())
                    },
                    tracks: tracks[id] ?? [],
                    powers: classPowers[id] ?? []
                )
            }
        }()

        let rituals = try {
            let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)Rituals.xlsx")
            return try table.enumerateRows().map { row in
                executionContext.put(.row, row)
                return try OPRitual(
                    id: table.at(col:"RITUAL", row).stringId(),
                    icon: table.at(col:"ICON", row).trimmed.nilIfEmpty,
                    circle: table.at(col:"CIRCLE", row).opCircle(),
                    element: table.at(col:"ELEMENT", row).opEffect(.elements),
                    costs: table.at(col:"COSTS", row).csv().map(Int.self)
                )
            }
        }()

        let weapons = try {
            let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)Weapons.xlsx")
            return try table.enumerateRows().map { row in
                executionContext.put(.row, row)
                return try OPWeapon(
                    id: table.at(col:"WEAPON", row).stringId(),
                    icon: table.at(col:"ICON", row).trimmed.nilIfEmpty,
                    load: table.at(col:"LOAD", row).int(),
                    category: table.at(col:"CATEGORY", row).opCategory(),
                    defenseBonus: try? table.at(col:"DEFENSE", row).expression(),
                    modifications: [],
                    level: table.at(col:"LEVEL", row).opProficiencyTag(.levels),
                    range: table.at(col:"RANGE", row).opProficiencyTag(.ranges),
                    handedness: table.at(col:"HANDEDNESS", row).opProficiencyTag(.handednesses),
                    hits: table.at(col:"HITS", row).csv().compactMap {
                        try RPGHit($0)?.opHit()
                    }
                )
            }
        }()

        let protections = try {
            let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)Protections.xlsx")
            return try table.enumerateRows().map { row in
                executionContext.put(.row, row)
                return try OPProtection(
                    id: table.at(col:"PROTECTION", row).stringId(),
                    icon: table.at(col:"ICON", row).trimmed.nilIfEmpty,
                    load: table.at(col:"LOAD", row).int(),
                    category: table.at(col:"CATEGORY", row).opCategory(),
                    defenseBonus: try? table.at(col:"DEFENSE", row).expression(),
                    modifications: [],
                    weight: table.at(col:"WEIGHT", row).opProficiencyTag(.weights)
                )
            }
        }()

        let items = try {
            let table = try load(table: "Loadables/Systems/\(systemId)/\(systemId)Items.xlsx")
            return try table.enumerateRows().map { row in
                executionContext.put(.row, row)
                return try OPItem(
                    id: table.at(col:"ITEM", row).stringId(),
                    icon: table.at(col:"ICON", row).trimmed.nilIfEmpty,
                    load: table.at(col:"LOAD", row).int(),
                    category: table.at(col:"CATEGORY", row).opCategory(),
                    defenseBonus: try? table.at(col:"DEFENSE", row).expression(),
                    domain: table.at(col:"DOMAIN", row).opDomain()
                )
            }
        }()

        return OPSystem(
            id: base.id,
            name: base.name,
            icon: base.icon,
            dynLocs: base.dynLocs,
            classes: classes,
            origins: origins,
            rituals: rituals,
            weapons: weapons,
            protections: protections,
            items: items
        )
    }
}

extension Array<String> {
    func map<T>(_ to: T.Type) throws -> Array<T> {
        switch to {
        case is Int.Type: map { Int($0)! as! T }
        case is Double.Type: map { Double($0)! as! T }
        default: throw ConversionError(to, [Int.self, Double.self])
        }
    }
}
