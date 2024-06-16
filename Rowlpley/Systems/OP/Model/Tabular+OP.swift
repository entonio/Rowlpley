//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Tabular

extension Slot {
    func opDomain() throws -> OPItemDomain {
        try OPItemDomain(text())
    }

    func opEffect(_ options: Set<OPEffect>) throws -> OPEffect {
        try OPEffect(text(), options)
    }

    func opProficiencyTag(_ options: Set<OPProficiencyTag>) throws -> OPProficiencyTag {
        try OPProficiencyTag(text(), options)
    }
}

extension Slot {
    func opCategory() throws -> OPItemCategory {
        try OPItemCategory(int())
    }

    func opCircle() throws -> OPRitualCircle {
        try OPRitualCircle(int())
    }
}
