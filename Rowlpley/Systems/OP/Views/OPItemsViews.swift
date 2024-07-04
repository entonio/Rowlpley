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

        Button {
            character.add(item: .custom)
        } label: {
            MenuLabel(nil, "Custom...")
        }
    }
}

struct OPItemsInventory: View {
    @Binding var character: OPCharacter

    var body: some View {
        ForEach(character.items.counted().sorted(usingKeys: [
            KeyPathComparator(\.domain)
        ]), id: \.key) {
            OPItemView(character: character, item: $0, count: $1)
        }
    }
}

struct OPItemView: View {
    let character: OPCharacter
    let item: OPItem
    let count: Int

    var body: some View {
        HStack {
            Text("\(count)")
            Text(item.name(character.system.op))
        }
    }
}
