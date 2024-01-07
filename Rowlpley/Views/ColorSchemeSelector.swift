//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct ColorSchemeSelector: View {
    @Binding var storableColorScheme: StorableColorScheme

    var body: some View {
        HStack {
            Text("Color Scheme:")
            Picker(selection: $storableColorScheme) {
                ForEach(StorableColorScheme.allCases, id: \.self) {
                    Text($0.name).tag($0)
                }
            } label: { }
                .pickerStyle(.segmented)
        }
    }
}
