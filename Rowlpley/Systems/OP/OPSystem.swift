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

    init(id: RPGSystemId, name: String, icon: String, dynLocs: Localizations, classes: [OPClass], origins: [OPOrigin]) {
        self.id = id
        self.name = name
        self.icon = icon
        self.dynLocs = dynLocs

        self.classes = classes
        self.origins = origins

        self.mClasses = classes.reduce(into: [:]) { $0[$1.id] = $1 }
        self.mTracks = classes.reduce(into: [:]) { map, classe in classe.tracks.forEach { map[$0.id] = $0 } }
        self.mOrigins = origins.reduce(into: [:]) { $0[$1.id] = $1 }
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
                try OPOrigin(
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
            return try table.enumerateRows().reduce(into: [OPClass.Id:[OPTrack.Id:[OPTrackPower]]]()) { byClass, row in
                let classe = try table.at(col:"CLASS", row).stringId().opClass(base.id)
                let track = try table.at(col:"TRACK", row).stringId().opTrack(base.id)
                let power = try OPTrackPower(
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

                var byTrack = byClass[classe] ?? [:]
                var trackPowers = byTrack[track] ?? []
                trackPowers.append(power)
                byTrack[track] = trackPowers
                byClass[classe] = byTrack
            }
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

        return OPSystem(id: base.id, name: base.name, icon: base.icon, dynLocs: base.dynLocs, classes: classes, origins: origins)
    }
}