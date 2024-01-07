//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//
// Project started 07/01/2024.
//

import SwiftUI
import SwiftData

@main
struct RowlpleyApp: App {

    @ObservedObject var loadables = RPGLoadables()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(loadables)
    }
}