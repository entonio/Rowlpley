//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI

struct OPNexView: View {
    @Binding var character: OPCharacter

    func nex() -> Binding<OPNex> {
        Binding(get: {
            character.nex
        }, set: {
            character.setNex($0)
        })
    }

    var body: some View {
        LRStack {
            Text("NEX")
            SelectView(nex(), options: OPNex.allCases, name: Block { "Level \($0.level) → \($0.percent) %" as LocalizedStringKey }) {
                HStack(spacing: 0) {
                    Text("\(character.nex.percent)%")
                        .foregroundStyle(character.nex.color)
                        .opWideNumber()
                    OPFormulaView("", character.nex.level, .opFormulaResult)
                }
            }
        } and: {
            HStack {
                Text("Movement")
                OPNumberInput(value: $character.movement, unit: "m")
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.opSecondaryInput)
            }
        }
    }
}

struct OPHitPointsView: View {
    @State var showEditor = false
    @Binding var character: OPCharacter

    var body: some View {
        let point1 = character.hitPoints
        let point2 = point1 + character.temporaryHitPoints
        let point3 = Swift.max(point2, character.hitPointsMax)
        ExtentsView(context: .groupedRow, [
            .init(point1, .opHitPoints),
            .init(point2, .opTemporaryHitPoints),
            .init(point3, .opExtentBackground),
        ]) {
            HStack {
                Text(OPStat.hitPoints.name)
                Spacer()
                OPFormulaView(character.classe.get.hitPoints, character.hitPointsMax, .opHitPoints)
                Text("\(character.hitPoints)")
                    .foregroundStyle(.opHitPoints)
                    .opNumber()
                    .toggleConditionalView($showEditor)

                OPNumberInput(value: $character.temporaryHitPoints)
                    .foregroundStyle(character.temporaryHitPoints > 0 ? .opTemporaryHitPoints : .opZero)
            }
        }
        .listRowSeparator(.hidden, edges: .bottom)

        ConditionalView(show: $showEditor) {
            LRStack {
                HStack {
                    Button { character.hitPoints(recover: 10) } label: { Text("10") }.rowButton(.opPointsGain(10))
                    Divider()
                    Button { character.hitPoints(recover:  5) } label: { Text( "5") }.rowButton(.opPointsGain(5))
                    Divider()
                    Button { character.hitPoints(recover:  1) } label: { Text( "↑ 🍔") }.rowButton(.opPointsGain(1))
                }
            } and: {
                HStack {
                    Button { character.hitPoints(lose:  1) } label: { Text( "🤜 ↓") }.rowButton(.opPointsLose(1))
                    Divider()
                    Button { character.hitPoints(lose:  5) } label: { Text( "5") }.rowButton(.opPointsLose(5))
                    Divider()
                    Button { character.hitPoints(lose: 10) } label: { Text("10") }.rowButton(.opPointsLose(10))
                }
            }
        }
    }
}

struct OPEffortPointsView: View {
    @State var showEditor = false
    @Binding var character: OPCharacter

    var body: some View {
        let point1 = character.effortPoints
        let point2 = character.effortPointsMax
        ExtentsView(context: .groupedRow, [
            .init(point1, .opEffortPoints),
            .init(point2, .opExtentBackground),
        ]) {
            HStack {
                Text(OPStat.effortPoints.name)
                Spacer()
                OPFormulaView(character.classe.get.effortPoints, character.effortPointsMax, .opEffortPoints)
                Text("\(character.effortPoints)")
                    .foregroundStyle(.opEffortPoints)
                    .opNumber()
                    .toggleConditionalView($showEditor)
            }
        }
        .listRowSeparator(.hidden, edges: .bottom)

        ConditionalView(show: $showEditor) {
            LRStack {
                HStack {
                    Button { character.effortPoints(recover: 10) } label: { Text("10") }.rowButton(.opPointsGain(10))
                    Divider()
                    Button { character.effortPoints(recover:  5) } label: { Text( "5") }.rowButton(.opPointsGain(5))
                    Divider()
                    Button { character.effortPoints(recover:  1) } label: { Text( "↑ 💎") }.rowButton(.opPointsGain(1))
                }
            } and: {
                HStack {
                    Button { character.effortPoints(lose: 1) } label: { Text("💸 ↓") }.rowButton(.opPointsLose(1))
                    Divider()
                    Button { character.effortPoints(lose: 3) } label: { Text("3") }.rowButton(.opPointsLose(3))
                    Divider()
                    Button { character.effortPoints(lose: 6) } label: { Text("6") }.rowButton(.opPointsLose(6))
                }
            }
        }
    }
}

struct OPSanityView: View {
    @State var showEditor = false
    @Binding var character: OPCharacter

    var body: some View {
        let point1 = character.sanity
        let point2 = character.sanityMax
        ExtentsView(context: .groupedRow, [
            .init(point1, .opSanity),
            .init(point2, .opExtentBackground),
        ]) {
            HStack {
                Text(OPStat.sanity.name)
                Spacer()
                OPFormulaView(character.classe.get.sanity, character.sanityMax, .opSanity)
                Text("\(character.sanity)")
                    .foregroundStyle(.opSanity)
                    .opNumber()
                    .toggleConditionalView($showEditor)
            }
        }
        .listRowSeparator(.hidden, edges: .bottom)

        ConditionalView(show: $showEditor) {
            LRStack {
                HStack {
                    Button { character.sanity(recover: 10) } label: { Text("10") }.rowButton(.opPointsGain(10))
                    Divider()
                    Button { character.sanity(recover:  5) } label: { Text( "5") }.rowButton(.opPointsGain(5))
                    Divider()
                    Button { character.sanity(recover:  1) } label: { Text( "↑ 🤙") }.rowButton(.opPointsGain(1))
                }
            } and: {
                HStack {
                    Button { character.sanity(lose:  1) } label: { Text( "😵‍💫 ↓") }.rowButton(.opPointsLose(1))
                    Divider()
                    Button { character.sanity(lose:  5) } label: { Text( "5") }.rowButton(.opPointsLose(5))
                    Divider()
                    Button { character.sanity(lose: 10) } label: { Text("10") }.rowButton(.opPointsLose(10))
                }
            }
        }
    }
}

struct OPDefensesView: View {
    @Binding var character: OPCharacter

    var body: some View {
        LRStack {
            Text("Defense")
        } and: {
            OPFormulaView(character.defense1, character.defense2, .opDefense)
            Text("\(character.defenseValue)")
                .foregroundStyle(.opDefense)
                .opNumber()
        }
    }
}
