//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct OPProtectionsMenu: View {
    @Binding var character: OPCharacter
    @EnvironmentObject var available: OPAvailableAddons

    var body: some View {
        let system = character.system.op
   
        ForEach(available.protections.sorted(using: KeyPathComparator(\.key)), id: \.key) { weight, protections in
            Section("\(Text(weight.icon)) \(Text(weight.name))") {
                ForEach(protections) { protection in
                    Button {
                        character.add(protection: protection)
                    } label: {
                        MenuLabel(protection.icon, protection.name(system))
                    }
                }
            }
        }

        Button {
            character.add(protection: .custom)
        } label: {
            MenuLabel(nil, "Custom...")
        }
    }
}

struct OPProtectionsInventory: View {
    @Binding var character: OPCharacter

    var body: some View {
        ForEach(character.protections.counted().sorted(usingKeys: [
            KeyPathComparator(\.weight, order: .reverse),
            KeyPathComparator(\.modifications.count, order: .reverse)
        ]) , id: \.key) {
            OPProtectionView(character: character, protection: $0, count: $1)
        }
    }
}

struct OPProtectionView: View {
    let character: OPCharacter
    let protection: OPProtection
    let count: Int

    var body: some View {
        HStack {
            Text("\(count)")
            Text(protection.name(character.system.op))
        }
    }
}
