//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI
import SwiftData
import OSLog

private let activeSection = 0
private let deletableSection = 1

struct NavigationView: View {
    @AppStorage("storableColorScheme") private var storableColorScheme: StorableColorScheme = .system

    @Environment(\.modelContext) private var modelContext

    @Query private var dnd5Characters: [DnD5Character]
    @Query private var opCharacters: [OPCharacter]

    @State private var modelVersion = 1
    var modelDidChange = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: RunLoop.main)

    var opAvailableAddons = OPAvailableAddons()

    @State private var selection: AnyHashable?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    private func allCharacters() -> [any RPGCharacter] {
        (dnd5Characters + opCharacters)
            .sorted {
                $0.name < $1.name
            }
    }

    var body: some View {
        let characters = allCharacters()

        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                VStack(spacing: 0) {
                    CharacterList(characters: characters, selection: $selection)
                        .listStyle(.insetGrouped)

                    if characters.hasContents {
                        Divider()
                    }

                    ColorSchemeSelector(storableColorScheme: $storableColorScheme)
                        .padding(.top, 4)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 6)
                        .background(characters.hasContents ? UIColor.tertiarySystemGroupedBackground.color : .clear)
                }
                .navigationTitle("Characters")
            },
            detail: {
                if let character = selection?.base as? DnD5Character {
                    DnD5CharacterView(character: .constant(character))
                } else if let character = selection?.base as? OPCharacter {
                    OPCharacterView(character: .constant(character))
                        .environmentObject(opAvailableAddons)
                        .onChange(of: modelVersion, initial: true) {
                            opAvailableAddons.update(character.system.op, opCharacters)
                        }
                } else if characters.hasContents {
                    Text("⬅︎ Select a character")
                } else {
                    Text("⬅︎ Add a character")
                }
            }
        )
        .navigationSplitViewStyle(.balanced)
        .preferredColorScheme(storableColorScheme.scheme)
        .onReceive(modelDidChange) { _ in
            modelVersion += 1
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [OPCharacter.self], inMemory: true)
}

