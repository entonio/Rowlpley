//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import Foundation

extension DnD5Character {
    convenience init(position: IndexPath, names: [String], player: String, system: DnD5System) {
        self.init(position: position, names: names, player: player, icon: nil, system: system.id)
    }
}
