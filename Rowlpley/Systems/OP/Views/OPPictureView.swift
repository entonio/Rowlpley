//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI
import PhotosUI

struct OPPictureView: View {
    @Binding var character: OPCharacter
    var pictureOpacity: Double

    @State var selection: PhotosPickerItem? = nil

    var body: some View {
        ZStack(alignment: character.graphicalOrientation.pictureAlignment) {
            Image(uiImage: character.iconOrDefault)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask(character.graphicalOrientation.pictureMask)
                .opacity(pictureOpacity)
                .scaleEffect(1.25, anchor: .center)

            VStack {
                PhotosPicker(
                    selection: $selection,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("📸")
                }
                .buttonStyle(PlainButtonStyle())
                .contextMenu {
                    Button {
                        character.icon = nil
                    } label: {
                        Label("Reset picture", systemImage: "minus.circle.fill")
                    }
                }
                .background(.white.opacity(0.7))

                Spacer()

                Button {
                    withAnimation {
                        character.graphicalOrientation = character.graphicalOrientation.opposite
                    }
                } label: {
                    Text("↔️")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onChange(of: selection) {
            if let selection {
                self.selection = nil
                Task {
                    if let data = try? await selection.loadTransferable(type: Data.self) {
                        if let icon = StorableImage(data) {
                            character.icon = icon
                        } else {
                            print("Failed")
                        }
                    } else {
                        print("Failed")
                    }
                }
            }
        }
    }
}



