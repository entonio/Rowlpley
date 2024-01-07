//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import Foundation

extension OPCharacter {
    convenience init(position: IndexPath, names: [String], player: String, system: OPSystem, nex: OPNex) {
        let classe = system.classes.randomElement()!
        self.init(
            position: position,
            names: names,
            player: player,
            system: system.id,
            classe: classe.id,
            track: classe.tracks.randomElement()!.id,
            origin: system.origins.randomElement()!.id,
            nex: nex,
            movement: 9,
            hitPoints: 0,
            temporaryHitPoints: 0,
            effortPoints: 0,
            sanity: 0,
            attributesTotal: 0,
            attributes: [:],
            attributeBonuses: [],
            classPowers: [],
            classSkills: [],
            trainingBySkill: [:],
            skillBonuses: [],
            resistances: [],
            rituals: [],
            ammunitions: [],
            weapons: [],
            items: []
        )
        
        attributesTotal = attributesBase
        randomiseAttributes()
        randomiseTraining()
        randomiseStats()
    }
}

extension OPAttribute {
    static func random(_ max: Int) -> [OPAttribute : Int] {
        var extra = max - Self.allCases.count
        var map = Self.allCases.reduce(into: [Self : Int]()) { result, item in
            if Bool.random() {
                result[item] = 1
            } else {
                result[item] = 0
                extra += 1
            }
        }
        while(extra  > 0) {
            let entry = map.randomElement()!
            map[entry.key] = entry.value + 1
            extra -= 1
        }
        return map
    }
}

extension OPSkill {
    static func choose(oneOf options: [[OPSkill]], excluding: [OPSkill]) -> [OPSkill] {
        options.map { $0.filter {
            !excluding.contains($0)
        }}
        .compactMap { $0.randomElement() }
    }

    static func random(baseSkills: [OPSkill], extraCount: Int) -> [OPSkill: Int] {

        var map = Self.allCases.reduce(into: [OPSkill: Int]()) { result, item in
            result[item] = 0
        }

        baseSkills.forEach {
            map[$0]! += OPSkill.trained
        }

        var leftToTrain = extraCount
        var trainingLimit = OPSkill.trained
        while(leftToTrain > 0) {
            var changed = false
            var unseen = map
            while(leftToTrain > 0 && unseen.hasContents) {
                let entry = unseen.randomElement()!
                unseen.removeValue(forKey: entry.key)
                var training = entry.value
                if training >= trainingLimit {
                    continue
                }
                training += OPSkill.trained
                if OPSkill.training.contains(training) {
                    map[entry.key] = training
                    leftToTrain -= 1
                    changed = true
                }
            }
            if trainingLimit > OPSkill.trained && !changed {
                break
            }
            trainingLimit += 5
        }

        baseSkills.forEach {
            map[$0]! -= OPSkill.trained
        }

        return map
    }
}
