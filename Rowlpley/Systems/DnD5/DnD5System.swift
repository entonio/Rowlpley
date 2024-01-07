//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

struct DnD5System: RPGSystem {
    var type: RPGSystemType { .DnD5 }

    let id: RPGSystemId
    let name: String
    let icon: String
    let dynLocs: Localizations
}

extension RPGSystemId {
    static let DnD5 = Self(id: "DnD5")
}

extension RPGSystemId {
    var dnd5: DnD5System { self.get.dnd5 }
}

extension RPGSystem {
    var dnd5: DnD5System { self as! DnD5System }
}

extension RPGLoadables {
    func loadDnD5(_ base: any RPGSystem) throws -> DnD5System {
        DnD5System(id: base.id, name: base.name, icon: base.icon, dynLocs: base.dynLocs)
    }
}
