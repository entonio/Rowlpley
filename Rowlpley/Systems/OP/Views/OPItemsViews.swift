//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct OPItemsMenu: View {
    @Binding var character: OPCharacter
    @EnvironmentObject var available: OPAvailableAddons

    var body: some View {
        let system = character.system.op
        ForEach(available.items.sorted(using: KeyPathComparator(\.key)), id: \.key) { domain, items in
            Section("\(Text(domain.icon)) \(Text(domain.name))") {
                ForEach(items) { item in
                    Button {
                        character.add(item: item)
                    } label: {
                        MenuLabel(item.icon, item.name(system))
                    }
                }
            }
        }
    }
}

struct OPItemView: View {
    var character: OPCharacter
    var item: OPItem

    var body: some View {
        Text(item.name(character.system.op))
    }
}
