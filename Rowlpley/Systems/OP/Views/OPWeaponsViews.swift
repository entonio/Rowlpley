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
    }
}

struct OPWeaponView: View {
    var character: OPCharacter
    var weapon: OPWeapon

    var body: some View {
        Text(weapon.name(character.system.op))
    }
}
