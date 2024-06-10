//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftData

extension RPGSystemType {
    var characterType: any PreloadablePersistentModel.Type {
        switch self {
        case .DnD5: DnD5Character.self
        case .OP:   OPCharacter.self
        }
    }
}

protocol PreloadablePersistentModel: PersistentModel {
    static func preloaded() -> [Self]
}

extension ModelContainer {
    @MainActor static func rpg() -> ModelContainer {
        let characterTypes = RPGSystemType.allCases.map(\.characterType)

        let preloadableTypes = characterTypes

        let schema = Schema(
            [AppSettings.self] + characterTypes
        )

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            let containerIsEmpty = try preloadableTypes.allSatisfy {
                try !container.contains($0)
            }

            if containerIsEmpty {
                preloadableTypes.forEach {
                    $0.preloaded().forEach {
                        container.mainContext.insert($0)
                    }
                }
            }

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

extension ModelContainer {
    @MainActor func contains<T: PersistentModel>(_ type: T.Type) throws -> Bool {
        var descriptor = FetchDescriptor<T>()
        descriptor.fetchLimit = 1
        let fetch = try mainContext.fetch(descriptor)
        return fetch.count > 0
    }
}
