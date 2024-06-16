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
    }
}

struct OPProtectionView: View {
    var character: OPCharacter
    var protection: OPProtection

    var body: some View {
        Text(protection.name(character.system.op))
    }
}
