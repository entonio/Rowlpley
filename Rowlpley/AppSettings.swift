//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class AppSettings {
    
    var player: String
    
    init(player: String) {
        self.player = player
    }
}
