//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI

struct OPRitualView: View {
    var character: OPCharacter
    var ritual: OPRitual

    var body: some View {
        Text(ritual.name(character.system.op))
    }
}
