//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI

struct OPSkillView: View {
    @Binding var character: OPCharacter
    var skill: OPSkill

    func training() -> Binding<Int> {
        Binding(get: {
            character.training(skill)
        }, set: {
            character.setTraining(skill, $0)
        })
    }

    var body: some View {
        HStack {
            Text(skill.name).frame(width: 128, alignment: .leading)

            Text(skill.attribute.label).font(.footnote).frame(width: 28)

            Text("=")

            HStack(spacing: 0) {
                let dice = OPDice(attribute: character.attribute(skill.attribute))
                Text(dice.sign)
                Text("\(dice.count)")
                    .foregroundStyle(.opAttribute(dice.count))
                Text("d")
                    .foregroundStyle(.opAttribute(dice.count).sharper())
            }
            .frame(width: 28, alignment: .trailing)

            OPSkillTrainingView(training: training())

            OPSkillBonusView(bonus: character.bonus(skill))
        }
        .frame(alignment: .leading)
    }
}

struct OPSkillTrainingView: View {
    @Binding var training: Int

    var body: some View {
        SelectView($training, options: OPSkill.training) {
            Text("\(training)")
                .foregroundStyle(.opSkillTraining(training))
                .opNumber()
        }
    }
}

struct OPSkillBonusView: View {
    var bonus: RPGModifier

    var body: some View {
        Text(bonus.description)
            .foregroundStyle(.opSkillBonus(bonus))
    }
}
