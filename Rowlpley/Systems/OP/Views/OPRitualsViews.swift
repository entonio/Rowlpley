//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct OPRitualsMenu: View {
    @Binding var character: OPCharacter
    @EnvironmentObject var available: OPAvailableAddons

    var body: some View {
        let system = character.system.op
        ForEach(available.rituals.sorted(using: KeyPathComparator(\.key)), id: \.key) { element, circles in
            Menu("\(Text(element.icon)) \(Text(element.name))") {
                ForEach(circles.sorted(using: KeyPathComparator(\.key)), id: \.key) { circle, rituals in
                    Section(circle.name) {
                        ForEach(rituals) { ritual in
                            Button {
                                character.add(ritual: ritual)
                            } label: {
                                MenuLabel(ritual.icon, ritual.name(system))
                            }
                        }
                    }
                }
            }
        }
    }
}

struct OPRitualView: View {
    var character: OPCharacter
    var ritual: OPRitual

    var body: some View {
        Text(ritual.name(character.system.op))
    }
}
