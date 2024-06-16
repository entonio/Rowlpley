//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

struct OPRitual: LocalizedObject, Codable, Hashable {
    let id: StringId
    let icon: String?
    let circle: Int
    let element: OPEffect
    let costs: [Int]
}

extension OPCharacter {
    func add(ritual: OPRitual) {
        rituals.append(ritual)
    }
}
