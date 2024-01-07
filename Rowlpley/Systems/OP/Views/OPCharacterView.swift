//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI

struct OPCharacterView: View {
    @Binding var character: OPCharacter

    var body: some View {
        List {
            let pictureOpacity = 1.0
            Section {
                VStack {
                    OPClassView(character: $character)
                    TrailingDivider()
                    OPTrackView(character: $character)
                    TrailingDivider()
                    OPOriginView(character: $character)
                }
            }
            .listRowBackground(
                (character.iconOrDefault.averageColor?.mixing(0.8, of: UIColor.secondarySystemGroupedBackground.dark)?.color ?? UIColor.secondarySystemGroupedBackground.dark.color).opacity(pictureOpacity)
            )
            .background(alignment: character.graphicalOrientation.pictureAlignment) {
                OPPictureView(character: $character, pictureOpacity: pictureOpacity)
            }

            Section(header: Text("Attributes")) {
                OPAttributesView(character: $character)
            }
            
            Section(header: Text("Stats")) {
                OPNexView(character: $character)
                OPHitPointsView(character: $character)
                OPEffortPointsView(character: $character)
                OPSanityView(character: $character)
                OPDefensesView(character: $character)
            }
            
            Section {
                ForEach(character.rituals) {
                    OPRitualView(character: character, ritual: $0)
                }
            } header: {
                HStack {
                    Text("Rituals")
                    Spacer()
                    Menu("Add Ritual ⚡", systemImage: "plus") {
                    }
                }
            }

            Section {
                ForEach(character.weapons) {
                    OPWeaponView(character: character, weapon: $0)
                }
            } header: {
                HStack {
                    Text("Weapons")
                    Spacer()
                    Menu("Add Weapon 🔫", systemImage: "plus") {
                    }
                }
            }

            Section {
                ForEach(character.items) {
                    OPItemView(character: character, item: $0)
                }
            } header: {
                HStack {
                    Text("Items")
                    Spacer()
                    Menu("Add Item 🎒", systemImage: "plus") {
                    }
                }
            }

            Section(header: Text("Skills")) {
                ForEach(OPSkill.allCases) {
                    OPSkillView(character: $character, skill: $0)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(.binding(character, array: \.names))
    }
}

#Preview {
    OPCharacterView(character: .constant(OPCharacter(position: IndexPath(row: 0, section: 0), names: ["C"], player: "P", system: OPSystem(id: RPGSystemId(id: "OP"), name: "OP", icon: "🍹", dynLocs: Localizations(), classes: [], origins: []), nex: OPNex(percent: 10))))
}
