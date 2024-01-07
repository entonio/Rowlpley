//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI

struct DnD5CharacterView: View {
    @Binding var character: DnD5Character
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                let size = 108.0
                Text("🛠️🪛🪚🔩🧱")
                    .font(.system(size: size))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, size / 2.5)
                    .padding(.vertical, size / 6)
                    .background(UIColor.secondarySystemGroupedBackground.color)
                    .cornerRadius(size / 4)
                
                Spacer()
            }
            Spacer()
        }
        .background(UIColor.systemGroupedBackground.color)
        .navigationTitle(character.name)
    }
}

#Preview {
    DnD5CharacterView(character: .constant(DnD5Character(position: IndexPath(row: 0, section: 0), names: ["C"], player: "P", icon: nil, system: RPGSystemId(id: "DnD5"))))
}
