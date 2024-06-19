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
                        ForEach(weapons) { weapon in
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
            KeyPathComparator(\.range),
            KeyPathComparator(\.level, order: .reverse),
            KeyPathComparator(\.modifications.count, order: .reverse)
        ]), id: \.key) { weapon, count in
            OPWeaponView(character: character, weapon: weapon, count: count)
        }
    }
}

struct OPWeaponView: View {
    let character: OPCharacter
    let weapon: OPWeapon
    let count: Int

    var body: some View {
        HStack {
            Text("\(count)")
            Text(weapon.name(character.system.op))
        }
    }
}
