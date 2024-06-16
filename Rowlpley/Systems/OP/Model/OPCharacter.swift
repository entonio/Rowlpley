//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftData
import UIKit
import Expressive

@Model
final class OPCharacter: RPGCharacter {

    var id: UUID
    var position: IndexPath
    var names: [String]
    var player: String
    var icon: StorableImage?
    var graphicalOrientation: GraphicalOrientation

    var system: RPGSystemId

    var classe: OPClass.Id
    var track: OPTrack.Id
    var origin: OPOrigin.Id

    var nex: OPNex
    var movement: Int
    var hitPoints: Int
    var temporaryHitPoints: Int
    var effortPoints: Int
    var sanity: Int
    var attributesTotal: Int

    var attributes: [OPAttribute: Int]
    var attributeBonuses: [OPAttributeBonus]

    var classPowers: [OPClassPower]
    var classSkills: [OPSkill]
    var trainingBySkill: [OPSkill: Int]
    var skillBonuses: [OPSkillBonus]

    var resistances: [OPResistance]
    var rituals: [OPRitual]
    var ammunitions: [OPAmmunition]
    var weapons: [OPWeapon]
    var protections: [OPProtection]
    var items: [OPItem]

    init(position: IndexPath, names: [String], player: String, icon: StorableImage? = nil, graphicalOrientation: GraphicalOrientation = .standard, system: RPGSystemId, classe: OPClass.Id, track: OPTrack.Id, origin: OPOrigin.Id, nex: OPNex, movement: Int, hitPoints: Int, temporaryHitPoints: Int, effortPoints: Int, sanity: Int, attributesTotal: Int, attributes: [OPAttribute : Int], attributeBonuses: [OPAttributeBonus], classPowers: [OPClassPower], classSkills: [OPSkill], trainingBySkill: [OPSkill : Int], skillBonuses: [OPSkillBonus], resistances: [OPResistance], rituals: [OPRitual], ammunitions: [OPAmmunition], weapons: [OPWeapon], protections: [OPProtection], items: [OPItem]) {
        self.id = UUID()
        self.position = position
        self.names = names
        self.player = player
        self.icon = icon
        self.graphicalOrientation = graphicalOrientation
        self.system = system
        self.classe = classe
        self.track = track
        self.origin = origin
        self.nex = nex
        self.movement = movement
        self.hitPoints = hitPoints
        self.temporaryHitPoints = temporaryHitPoints
        self.effortPoints = effortPoints
        self.sanity = sanity
        self.attributesTotal = attributesTotal
        self.attributes = attributes
        self.attributeBonuses = attributeBonuses
        self.classPowers = classPowers
        self.classSkills = classSkills
        self.trainingBySkill = trainingBySkill
        self.skillBonuses = skillBonuses
        self.resistances = resistances
        self.rituals = rituals
        self.ammunitions = ammunitions
        self.weapons = weapons
        self.protections = protections
        self.items = items
    }

    enum CodingKeys: String, CodingKey {
        case id
        case position
        case names
        case player
        case icon
        case graphicalOrientation
        case system
        case classe
        case track
        case origin
        case nex
        case movement
        case hitPoints
        case temporaryHitPoints
        case effortPoints
        case sanity
        case attributesTotal
        case attributes
        case attributeBonuses
        case classPowers
        case classSkills
        case trainingBySkill
        case skillBonuses
        case resistances
        case rituals
        case ammunitions
        case weapons
        case protections
        case items
    }

    // SimpleCodable does not currently support dictionaries nor nested types

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.position = try container.decode(IndexPath.self, forKey: .position)
        self.names = try container.decode([String].self, forKey: .names)
        self.player = try container.decode(String.self, forKey: .player)
        self.icon = try container.decodeIfPresent(StorableImage.self, forKey: .icon)
        self.graphicalOrientation = try container.decode(GraphicalOrientation.self, forKey: .graphicalOrientation)
        self.system = try container.decode(RPGSystemId.self, forKey: .system)
        self.classe = try container.decode(OPClass.Id.self, forKey: .classe)
        self.track = try container.decode(OPTrack.Id.self, forKey: .track)
        self.origin = try container.decode(OPOrigin.Id.self, forKey: .origin)
        self.nex = try container.decode(OPNex.self, forKey: .nex)
        self.movement = try container.decode(Int.self, forKey: .movement)
        self.hitPoints = try container.decode(Int.self, forKey: .hitPoints)
        self.temporaryHitPoints = try container.decode(Int.self, forKey: .temporaryHitPoints)
        self.effortPoints = try container.decode(Int.self, forKey: .effortPoints)
        self.sanity = try container.decode(Int.self, forKey: .sanity)
        self.attributesTotal = try container.decode(Int.self, forKey: .attributesTotal)
        self.attributes = try container.decode([OPAttribute: Int].self, forKey: .attributes)
        self.attributeBonuses = try container.decode([OPAttributeBonus].self, forKey: .attributeBonuses)
        self.classPowers = try container.decode([OPClassPower].self, forKey: .classPowers)
        self.classSkills = try container.decode([OPSkill].self, forKey: .classSkills)
        self.trainingBySkill = try container.decode([OPSkill: Int].self, forKey: .trainingBySkill)
        self.skillBonuses = try container.decode([OPSkillBonus].self, forKey: .skillBonuses)
        self.resistances = try container.decode([OPResistance].self, forKey: .resistances)
        self.rituals = try container.decode([OPRitual].self, forKey: .rituals)
        self.ammunitions = try container.decode([OPAmmunition].self, forKey: .ammunitions)
        self.weapons = try container.decode([OPWeapon].self, forKey: .weapons)
        self.protections = try container.decode([OPProtection].self, forKey: .protections)
        self.items = try container.decode([OPItem].self, forKey: .items)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(position, forKey: .position)
        try container.encode(names, forKey: .names)
        try container.encode(player, forKey: .player)
        try container.encode(icon, forKey: .icon)
        try container.encode(graphicalOrientation, forKey: .graphicalOrientation)
        try container.encode(system, forKey: .system)
        try container.encode(classe, forKey: .classe)
        try container.encode(track, forKey: .track)
        try container.encode(origin, forKey: .origin)
        try container.encode(nex, forKey: .nex)
        try container.encode(movement, forKey: .movement)
        try container.encode(hitPoints, forKey: .hitPoints)
        try container.encode(temporaryHitPoints, forKey: .temporaryHitPoints)
        try container.encode(effortPoints, forKey: .effortPoints)
        try container.encode(sanity, forKey: .sanity)
        try container.encode(attributesTotal, forKey: .attributesTotal)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(attributeBonuses, forKey: .attributeBonuses)
        try container.encode(classPowers, forKey: .classPowers)
        try container.encode(classSkills, forKey: .classSkills)
        try container.encode(trainingBySkill, forKey: .trainingBySkill)
        try container.encode(skillBonuses, forKey: .skillBonuses)
        try container.encode(resistances, forKey: .resistances)
        try container.encode(rituals, forKey: .rituals)
        try container.encode(ammunitions, forKey: .ammunitions)
        try container.encode(weapons, forKey: .weapons)
        try container.encode(protections, forKey: .protections)
        try container.encode(items, forKey: .items)
    }
}

extension OPCharacter {
    var iconOrDefault: UIImage {
        icon?.uiImage ?? UIImage(named: RPGMedia.picture(.OP, characterNames: names))!
    }
}

extension OPCharacter {
    func resetStats() {
        hitPoints = hitPointsMax
        effortPoints = effortPointsMax
        sanity = sanityMax
    }

    func randomiseStats() {
        hitPoints = Int.random(in: 0...hitPointsMax)
        effortPoints = Int.random(in: 0...effortPointsMax)
        sanity = Int.random(in: 0...sanityMax)
    }
}

extension OPCharacter {
    func has(_ power: OPTrackPower) -> Bool {
        nex >= power.nex && track.get.powers.contains { $0.id == power.id }
    }

    func has(_ proficiency: OPProficiency) -> Bool {
        proficiencies.contains { $0.contains(proficiency) }
    }
}

extension OPProficiency {
    var implicitTags: Set<OPProficiencyTag> {
        if tags.contains(.weapons) {
            return tags.inMissingSets(
                .levels,
                .ranges,
                .handednesses
            ).toSet()
        }
        if tags.contains(.protections) {
            return tags.inMissingSets(
                .weights
            ).toSet()
        }
        return []
    }

    func contains(_ other: OPProficiency) -> Bool {
        let notDirectlyCovered = other.tags.subtracting(tags)
        return notDirectlyCovered.isEmpty || notDirectlyCovered.subtracting(implicitTags).isEmpty
    }
}

extension OPCharacter {
    var proficiencies: [OPProficiency] {
        classe.get.proficiencies
        +
        track.get.powers.filter { nex >= $0.nex }.flatMap { $0.proficiencies }
    }
}

extension OPCharacter {
    func resetBaseSkills() {
        classSkills = OPSkill.choose(
            oneOf: classe.get.baseSkillsOptions,
            excluding: origin.get.baseSkills
        )
    }
    
    func randomiseTraining() {
        resetBaseSkills()
        trainingBySkill = OPSkill.random(
            baseSkills: classSkills + origin.get.baseSkills,
            extraCount: extraSkillsCount
        )
    }
}

extension OPCharacter {
    func attribute(_ type: OPAttribute) -> Int {
        return attributes[type]!
    }
    
    func setAttribute(_ type: OPAttribute, _ value: Int) {
        attributes[type] = value
    }

    func randomiseAttributes() {
        attributes = OPAttribute.random(attributesBase)
    }
}

extension OPCharacter {
    func bonus(_ attribute: OPAttribute) -> RPGModifier {
        attributeBonuses.reduce(.zero) {
            $1.attribute == attribute ? $0 + $1.modifier : $0
        }
    }

    func bonus(_ skill: OPSkill) -> RPGModifier {
        skillBonuses.reduce(.zero) {
            $1.skill == skill ? $0 + $1.modifier : $0
        }
    }
}

extension OPCharacter {
    func training(_ skill: OPSkill) -> Int {
        (trainingBySkill[skill] ?? 0) + baseTraining(skill)
    }

    func setTraining(_ skill: OPSkill, _ value: Int) {
        trainingBySkill[skill] = value - baseTraining(skill)
    }

    func baseTraining(_ skill: OPSkill) -> Int {
        if classSkills.contains(skill) || origin.get.baseSkills.contains(skill) {
            return OPSkill.training[1]
        }
        return 0
    }
}
