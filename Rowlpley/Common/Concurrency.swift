//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

final class Locked<Resource: Any>: Sendable {
    private let lock = NSLock()
    nonisolated(unsafe) private var resource: Resource

    init(_ resource: Resource) {
        self.resource = resource
    }

    func `do`<Result: Any>(_ action: (inout Resource) throws -> Result) rethrows -> Result {
        lock.lock()
        defer { lock.unlock() }

        return try action(&resource)
    }
}
