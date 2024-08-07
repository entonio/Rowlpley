//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//
// Project started 07/01/2024.
//

import SwiftUI
import SwiftData

@main
struct RowlpleyApp: App {

    var loadables = RPGLoadables()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(loadables)
    }
}

let executionContext = TypedCache(ttl: 30)

extension TypedMapKey where ValueType == String {
    static let table = TypedMapKey()
}

extension TypedMapKey where ValueType == Int {
    static let row = TypedMapKey()
}
