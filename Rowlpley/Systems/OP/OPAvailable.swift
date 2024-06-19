//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

class OPAvailableAddons: ObservableObject {
    @Published var rituals: [OPEffect: [OPRitualCircle: [OPRitual]]] = [:]
    @Published var weapons: [OPProficiencyTag: [OPProficiencyTag: [OPWeapon]]] = [:]
    @Published var protections: [OPProficiencyTag: [OPProtection]] = [:]
    @Published var items: [OPItemDomain: [OPItem]] = [:]
}

extension OPAvailableAddons {
    func update(_ system: OPSystem, _ characters: [OPCharacter]) {
        rituals = Set(system.rituals + characters.flatMap { $0.rituals })
            .grouped(by: \.element, \.circle)

        weapons = Set(system.weapons + characters.flatMap { $0.weapons })
            .grouped(by: \.range, \.level)

        protections = Set(system.protections + characters.flatMap { $0.protections })
            .grouped(by: \.weight)

        items = Set(system.items + characters.flatMap { $0.items })
            .grouped(by: \.domain)
    }
}
