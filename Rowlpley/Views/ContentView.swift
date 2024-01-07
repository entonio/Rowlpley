//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentView: View {

    @EnvironmentObject var loadables: RPGLoadables

    var body: some View {
        if loadables.status == .ready {
            NavigationView()
                .modelContainer(.rpg())
        } else {
            LoadingView()
        }
    }
}
