//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import OSLog

class RPGLoadables: ObservableObject {
    enum Status {
        case idle
        case updating
        case loading
        case ready
        case cancelled
    }

    @Published private(set) var status: Status = .idle

    func dispatchStatus(_ status: Status) {
        DispatchQueue.main.async {
            self.status = status
        }
    }


    init() {
        reset()
    }

    func reset() {
        Task {
            do {
                dispatchStatus(.updating)
                try await update()
            } catch {
                Logger().warning("Could not update: [\(error)]")
            }

            do {
                dispatchStatus(.loading)
                try load()
            } catch {
                Logger().warning("Could not load: [\(error)]")
                return dispatchStatus(.cancelled)
            }

            dispatchStatus(.ready)
        }
    }
}
