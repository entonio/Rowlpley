//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI
import WrappingHStack

struct OPClassView: View {
    @Binding var character: OPCharacter

    func classe() -> Binding<OPClass.Id> {
        Binding(get: {
            character.classe
        }, set: {
            if character.classe != $0 {
                character.classe = $0
                character.resetBaseSkills()
            }
        })
    }
    
    var body: some View {
        let system = character.system.op

        SelectView(classe(), options: system.classes, name: Block { $0.name(system) }) {
            Text(character.classe.get.name(system))
        }
        .opOverlaySelect()
        .traitSelector(character.graphicalOrientation)

        WrappingHStack(
            style: .spaced,
            alignment: character.graphicalOrientation.traitsAlignment,
            character.graphicalOrientation.traitsLabels(
                character.classSkills as [Any],
                character.classe.get.proficiencies
            )
        ) {
            if let skill = $0 as? OPSkill {
                Text(skill.name)
                    .opSkill()
            } else if let proficiency = $0 as? OPProficiency {
                Text(proficiency.name(system))
                    .opProficiency(true)
            }
        }
    }
}

struct OPTrackView: View {
    @Binding var character: OPCharacter

    var body: some View {
        let system = character.system.op

        SelectView($character.track, options: character.classe.get.tracks, name: Block { $0.name(system) }) {
            Text(character.track.get.name(system))
        }
        .opOverlaySelect()
        .traitSelector(character.graphicalOrientation)

        WrappingHStack(
            style: .spaced,
            alignment: character.graphicalOrientation.traitsAlignment,
            character.graphicalOrientation.traitsLabels(
                character.track.get.powers.reversed().flatMap {
                    $0.proficiencies as [Any] + [$0]
                }
            )
        ) {
            if let power = $0 as? OPTrackPower {
                Text(power.name(system))
                    .opPower(character.has(power))
            } else if let proficiency = $0 as? OPProficiency {
                Text(proficiency.name(system))
                    .opProficiency(character.has(proficiency))
            }
        }
    }
}

struct OPOriginView: View {
    @Binding var character: OPCharacter

    func origin() -> Binding<OPOrigin.Id> {
        Binding(get: {
            character.origin
        }, set: {
            if character.origin != $0 {
                character.origin = $0
                character.resetBaseSkills()
            }
        })
    }

    var body: some View {
        let system = character.system.op

        SelectView(origin(), options: system.origins, name: Block { $0.name(system) }) {
            Text(character.origin.get.name(
                system))
        }
        .opOverlaySelect()
        .traitSelector(character.graphicalOrientation)

        WrappingHStack(
            style: .spaced,
            alignment: character.graphicalOrientation.traitsAlignment,
            character.graphicalOrientation.traitsLabels(
                [character.origin.get.power],
                character.origin.get.baseSkills
            )
        ) {
            if let skill = $0 as? OPSkill {
                Text(skill.name)
                    .opSkill()
            } else if let power = $0 as? OPOriginPower {
                Text(power.name(
                    system))
                .opPower(true)
            }
        }
    }
}
