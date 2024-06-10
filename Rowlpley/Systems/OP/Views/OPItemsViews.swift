//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct OPProtectionView: View {
    var character: OPCharacter
    var protection: OPProtection

    var body: some View {
        Text(protection.name(character.system.op))
    }
}
