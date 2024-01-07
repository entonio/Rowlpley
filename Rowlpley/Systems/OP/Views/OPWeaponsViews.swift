//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI

struct OPWeaponView: View {
    var character: OPCharacter
    var weapon: OPWeapon

    var body: some View {
        Text(weapon.name(character.system.op))
    }
}
