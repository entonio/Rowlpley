//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct OPWeaponsMenu: View {
    @Binding var character: OPCharacter
    @EnvironmentObject var available: OPAvailableAddons

    var body: some View {
        let system = character.system.op

        ForEach(available.weapons.sorted(using: KeyPathComparator(\.key)), id: \.key) { range, levels in
            Menu("\(Text(range.icon)) \(Text(range.name))") {
                ForEach(levels.sorted(using: KeyPathComparator(\.key)), id: \.key) { level, weapons in
                    Section("\(Text(level.icon)) \(Text(level.name))") {
                        ForEach(weapons, id: \.self) { weapon in
                            Button {
                                character.add(weapon: weapon)
                            } label: {
                                MenuLabel(weapon.icon, weapon.name(system))
                            }
                        }
                    }
                }
            }
        }

        Section {
            Button {
                character.add(weapon: .custom)
            } label: {
                MenuLabel(nil, "Custom...")
            }
        }
    }
}

struct OPWeaponsInventory: View {
    @Binding var character: OPCharacter

    var body: some View {
        ForEach(character.weapons.counted().sorted(usingKeys: [
                KeyPathComparator(\.range, order: .reverse),
                KeyPathComparator(\.level, order: .reverse),
                KeyPathComparator(\.modifications.count, order: .reverse),
                KeyPathComparator(\.id.content),
            ]), id: \.key) {
            OPWeaponView(character: $character, weapon: $0, count: $1)
        }
    }
}

struct OPWeaponView: View {
    @State private var showDetails = false

    @Binding var character: OPCharacter
    let weapon: OPWeapon
    let count: Int

    var body: some View {
        OPEquipableMain(toggleDetails: $showDetails) {
            MinusButton(count > 1, "Delete weapon?") {
                character.drop(weapon: weapon)
            }

            ColoredText("\(count)")

            if let icon = weapon.icon {
                Text(icon)
            }

            TextInput("", text: Binding {
                weapon.name(character.system.op)
            } set: {
                character.replace(weapon: weapon, by: weapon.with(
                    id: $0.text?.stringId()
                ))
            })
            .fixedSize()

            Spacer()

            ForEach(weapon.hits, id: \.self) {
                MultiText([
                    $0.modifier.expression.solve().description,
                    $0.type.icon
                    //                    " ",
                    //                    LetterView($0.type.name, .white, .red.mixing(0.2, of: .white)!)
                ])
            }

            TextInput("", text: Binding {
                "\("Crit".localized().capital)\(weapon.crit.difficulty) / x\(weapon.crit.multiplier)"
            } set: {
                if let crit = try? OPCriticalHit($0) {
                    character.replace(weapon: weapon, by: weapon.with(
                        crit: crit
                    ))
                }
            })
            .fixedSize()

            if !(weapon.handedness =~ .basics) {
                Text(weapon.handedness.icon)
                //                LetterView(weapon.handedness.icon)
            }

            PlusButton {
                character.add(weapon: weapon)
            }
        }

        OPEquipableDetails(show: $showDetails) {
            Text("🎒 \(weapon.load)")
            Spacer()
            Text("↔ \(weapon.range.icon)")
            Spacer()
            Text("🎖️ \(weapon.level.icon) \(weapon.category.icon)")
        }
    }
}

struct OPEquipableMain<Content: View> : View {
    @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory

    let toggleDetails: Binding<Bool>
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack {
            content()
                .font(.system(sizeCategory, size: 12))
        }
        .toggleWithAnimation(toggleDetails)
        .listRowSeparator(toggleDetails.wrappedValue ? .hidden : .automatic, edges: .bottom)
    }
}

struct OPEquipableDetails<Content: View> : View {
    @Environment(\.colorScheme) private var colorScheme

    let show: Binding<Bool>
    @ViewBuilder let content: () -> Content

    var body: some View {
        if show.wrappedValue {
            HStack {
                content()
            }
            .listRowBackground(UIColor.secondarySystemGroupedBackground.resolvedColor(with: colorScheme).mixing(0.03, of: UIColor.secondaryLabel.resolvedColor(with: colorScheme))!.color)
        }
    }
}
