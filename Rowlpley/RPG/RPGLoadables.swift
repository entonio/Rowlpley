//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import OSLog

class RPGLoadables: ObservableObject {
    enum Status: Equatable {
        case idle
        case updating
        case loading
        case ready
        case cancelled(String)
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
                let table = executionContext.get(.table)?.lastPathComponent
                let row = executionContext.get(.row)
                var context = (error as CustomStringConvertible).description
                if let table, let row {
                    context = "\(table):\(row + 1): \(context)"
                } else if let table {
                    context = "\(table): \(context)"
                }
                Logger().warning("Could not load system: [\(context)]")
                return dispatchStatus(.cancelled(context))
            }

            dispatchStatus(.ready)
        }
    }
}

extension RPGLoadables.Status {
    var cancelled: String? {
        switch self {
        case .cancelled(let value): value
        default: nil
        }
    }
}
