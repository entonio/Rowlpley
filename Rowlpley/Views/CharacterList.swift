//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI
import SwiftData
import OSLog

private let activeSection = 0
private let deletableSection = 1

struct CharacterList: View {
    var characters: [any RPGCharacter]
    @Binding var selection: AnyHashable?

    @Environment(\.modelContext) private var modelContext

    @Query private var settings: [AppSettings]

    @State private var alert: (show: Bool, title: LocalizedStringKey, message: LocalizedStringKey) = (false, "", "")

    @State private var showImportCharacters = false
    @State private var showExportCharacters = false
    @State private var charactersToExport: [RowlPC] = []

    var body: some View {
        VStack(spacing: 0) {
            List(selection: $selection) {
                let active = characters.filter { $0.position.section == activeSection }
                if active.hasContents {
                    section(active: active)
                }

                let deletable = characters.filter { $0.position.section == deletableSection }
                if deletable.hasContents {
                    section(deletable: deletable)
                }
            }
            .toolbar {
                toolbarImportExport()
                toolbarAddCharacter()
            }
            .fileImporter(isPresented: $showImportCharacters, allowedContentTypes: [.rowlpc], allowsMultipleSelection: true, onCompletion: didImportCharacterFiles)
            .fileExporter(isPresented: $showExportCharacters, documents: charactersToExport, contentTypes: [.rowlpc], onCompletion: didExportCharacterFiles)
            .alert(alert.title, isPresented: $alert.show) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(alert.message)
            }
        }
    }
}

extension CharacterList {
    private func section(active: [any RPGCharacter]) -> some View {
        Section(header: Text("Active")) {
            ForEach(active, id: \.id) { character in
                CharacterLink(character: .constant(character))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            move(character, to: deletableSection)
                        } label: {
                            Label("Move to Deletable", systemImage: "archivebox.fill")
                        }
                    }
            }
        }
    }

    private func section(deletable: [any RPGCharacter]) -> some View {
        Section(header: Text("Deletable")) {
            ForEach(deletable, id: \.id) { character in
                CharacterLink(character: .constant(character))
                    .swipeActions(edge: .leading) {
                        Button(role: .cancel) {
                            move(character, to: activeSection)
                        } label: {
                            Label("Restore", systemImage: "arrowshape.turn.up.backward.fill")
                        }
                        .tint(.indigo)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            delete(character)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
            }
        }
    }

    private func toolbarImportExport() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button {
                    showImportCharacters = true
                } label: {
                    Text("Import Characters")
                }

                if characters.hasContents {
                    Button {
                        charactersToExport = DeSerializer().serializedCharacters(characters)
                        showExportCharacters = true
                    } label: {
                        Text("Export Characters")
                    }
                }
            } label: {
                Label("Import / Export", systemImage: "square.and.arrow.down.on.square")
            }
        }
    }

    private func toolbarAddCharacter() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                ForEach(RPGSystemId.systems, id: \.id) { system in
                    Button {
                        addCharacter(system: system)
                    } label: {
                        Text(system.name)
                    }
                }
            } label: {
                Label("Add Character", systemImage: "plus")
            }
        }
    }
}

extension CharacterList {
    func didExportCharacterFiles(_ result: Result<[URL], any Error>) {
        switch result {
        case .success(_): break
        case .failure(let error):
            alert = (true, "Error", "Could not export the characters")
            Logger().warning("While importing character files: \(error)")
        }
        charactersToExport = []
    }

    func didImportCharacterFiles(_ result: Result<[URL], any Error>) {
        switch result {
        case .success(let urls):
            let (imported, skipped) = DeSerializer().deserializedCharacters(urls).reduce([any RPGCharacter](), [URL]()) {
                if let character = $0.character {
                    $1.append(character)
                } else {
                    $2.append($0.url)
                }
            }

            if imported.hasContents {
                addCharacters(imported)
            }

            if skipped.hasContents {
                alert = (true, "Files skipped", "\(skipped.map { $0.lastPathComponent }.lines())")
            }

        case .failure(let error):
            alert = (true, "Error", "Could not read the selected files")
            Logger().warning("While importing character files: \(error)")
        }
    }
}

extension CharacterList {
    private func addCharacters(_ toAdd: [any RPGCharacter]) {
        var character: (any RPGCharacter)?
        toAdd.forEach {
            character = $0
            withAnimation {
                character?.position = IndexPath(row: 0, section: activeSection)
                if let character = character as? DnD5Character {
                    modelContext.insert(character)
                } else if let character = character as? OPCharacter {
                    modelContext.insert(character)
                }
            }
        }
        withAnimation {
            if let character = character as? DnD5Character {
                selection = character
            } else if let character = character as? OPCharacter {
                selection = character
            }
        }
    }

    private func addCharacter(system: any RPGSystem) {
        withAnimation {
            let position = IndexPath(row: 0, section: activeSection)
            let names = RPGNames.randomName(system.type)
            let player = settings.first?.player ?? ""

            switch system.type {
            case .DnD5:
                let character = DnD5Character(position: position, names: names, player: player, icon: nil, system: system.id)
                modelContext.insert(character)
                selection = character
            case .OP:
                let character = OPCharacter(position: position, names: names, player: player, system: system.op, nex: OPNex(percent: 10))
                modelContext.insert(character)
                selection = character
            }
        }
    }

    private func move(_ character: any RPGCharacter, to section: Int) {
        withAnimation {
            switch character {
            case let character as DnD5Character:
                character.position.section = section
                if section == deletableSection, selection?.base as? DnD5Character == character {
                    selection = nil
                }
            case let character as OPCharacter:
                character.position.section = section
                if section == deletableSection, selection?.base as? OPCharacter == character {
                    selection = nil
                }
            default: break
            }
        }
    }

    private func delete(_ character: any RPGCharacter) {
        withAnimation {
            switch character {
            case let character as DnD5Character: modelContext.delete(character)
                if selection?.base as? DnD5Character == character {
                    selection = nil
                }
            case let character as OPCharacter:   modelContext.delete(character)
                if selection?.base as? OPCharacter == character {
                    selection = nil
                }
            default: break
            }
        }
    }
}
