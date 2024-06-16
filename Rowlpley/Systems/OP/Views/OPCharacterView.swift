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
            
            let system = character.system.op

            Section {
                ForEach(character.rituals) {
                    OPRitualView(character: character, ritual: $0)
                }
            } header: {
                HStack {
                    Text("Rituals")
                    Spacer()
                    Menu("Add Ritual ⚡", systemImage: "plus") {
                        ForEach(available.rituals) { ritual in
                            Button {
                                character.add(ritual: ritual)
                            } label: {
                                MenuLabel(ritual.icon, ritual.name(system))
                            }
                        }
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
                        ForEach(available.weapons) { weapon in
                            Button {
                                character.add(weapon: weapon)
                            } label: {
                                MenuLabel(weapon.icon, weapon.name(system))
                            }
                        }
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
                        ForEach(available.protections) { protection in
                            Button {
                                character.add(protection: protection)
                            } label: {
                                MenuLabel(protection.icon, protection.name(system))
                            }
                        }
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
                        ForEach(available.items) { item in
                            Button {
                                character.add(item: item)
                            } label: {
                                MenuLabel(item.icon, item.name(system))
                            }
                        }
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

class OPAvailableAddons: ObservableObject {
    @Published var rituals: [OPRitual] = []
    @Published var weapons: [OPWeapon] = []
    @Published var protections: [OPProtection] = []
    @Published var items: [OPItem] = []
}

extension OPAvailableAddons {
    func update(_ system: OPSystem, _ characters: [OPCharacter]) {
        rituals = Set(system.rituals + characters.flatMap { $0.rituals }).sorted(using: KeyPathComparator(\.id.content))
        weapons = Set(system.weapons + characters.flatMap { $0.weapons }).sorted(using: KeyPathComparator(\.id.content))
        protections = Set(system.protections + characters.flatMap { $0.protections }).sorted(using: KeyPathComparator(\.id.content))
        items = Set(system.items + characters.flatMap { $0.items }).sorted(using: KeyPathComparator(\.id.content))
    }
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
