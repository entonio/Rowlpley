//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct CharacterLink: View {
    @Binding var character: any RPGCharacter

    var body: some View {
        NavigationLink(value: AnyHashable(character)) {
            Label {
                Text(character.name)
            } icon: {
                if let icon = character.icon?.uiImage {
                    Image(uiImage: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .characterIconSize, height: .characterIconSize)
                        .background(icon.averageColor?.color)
                        .cornerRadius(.characterIconSize / 2)
                } else {
                    Text(character.system.get.icon)
                }
            }
        }
    }
}
