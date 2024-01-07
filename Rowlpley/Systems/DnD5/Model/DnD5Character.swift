//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//
      
import Foundation
import SwiftData
import SimpleCodable
import UIKit

@Model
@Codable
final class DnD5Character: RPGCharacter {

    var id: UUID
    var position: IndexPath
    var names: [String]
    var player: String
    var icon: StorableImage?

    var system: RPGSystemId

    init(position: IndexPath, names: [String], player: String, icon: StorableImage?, system: RPGSystemId) {
        self.id = UUID()
        self.position = position
        self.names = names
        self.player = player
        self.icon = icon
        self.system = system
    }
}
