//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI

struct OPCharacterView: View {
    @Binding var character: OPCharacter
    
    @EnvironmentObject var available: OPAvailableAddons

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
                        OPRitualsMenu(character: $character)
                    }
                    .sectionMenu()
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
                        OPWeaponsMenu(character: $character)
                    }
                    .sectionMenu()
                }
            }

            Section {
                ForEach(character.protections) {
                    OPProtectionView(character: character, protection: $0)
                }
            } header: {
                HStack {
                    Text("Protections")
                    Spacer()
                    Menu("Add Protection 👷", systemImage: "plus") {
                        OPProtectionsMenu(character: $character)
                    }
                    .sectionMenu()
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
                    Menu("Add Item 👜", systemImage: "plus") {
                        OPItemsMenu(character: $character)
                    }
                    .sectionMenu()
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
    OPCharacterView(character: .constant(OPCharacter(position: IndexPath(row: 0, section: 0), names: ["C"], player: "P", system: OPSystem(id: RPGSystemId(id: "OP"), name: "OP", icon: "🍹", dynLocs: Localizations(), classes: [], origins: [], rituals: [], weapons: [], protections: [], items: []), nex: OPNex(percent: 10))))
        .environmentObject(OPAvailableAddons())
}

struct MenuLabel: View {
    let icon: String?
    let main: String

    init(_ icon: String? = nil, _ main: String) {
        self.icon = icon
        self.main = main
    }

    var body: some View {
        Text(text)
    }

    var text: String {
        if let icon {
            "\(icon) \(main)"
        } else {
            main
        }
    }
}
