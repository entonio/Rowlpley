//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI

struct OPItemView: View {
    var character: OPCharacter
    var item: OPItem

    var body: some View {
        Text(item.name(character.system.op))
    }
}
