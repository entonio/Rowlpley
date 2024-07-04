//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import OSLog

@MainActor
class RPGLoadables: ObservableObject {
    enum Status: Equatable {
        case idle
        case updating
        case loading
        case ready
        case cancelled(String)
    }

    @Published private(set) var status: Status = .idle

    fileprivate func setStatus(_ status: Status) {
        self.status = status
    }

    init() {
        reset()
    }

    func reset() {
        Task {
            await RPGLoader().run(for: self)
        }
    }
}

struct RPGLoader {
    func run(for loadables: RPGLoadables) async {
        do {
            await loadables.setStatus(.updating)
            try await update()
        } catch {
            Logger().warning("Could not update: [\(error)]")
        }

        do {
            await loadables.setStatus(.loading)
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
            await loadables.setStatus(.cancelled(context))
            return
        }

        await loadables.setStatus(.ready)
        return
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
