//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

final class TypedCache: Sendable {
    private let lock = NSLock()
    nonisolated(unsafe) private var entries: [AnyHashable: (Date, Any)] = [:]

    private let ttl: TimeInterval

    init(ttl: TimeInterval) {
        self.ttl = ttl
    }

    func put<V>(_ key: TypedMapKey<V>, _ value: V) {
        lock.lock()
        defer { lock.unlock() }
        
        entries[key] = (Date.now, value)
    }

    func delete<V>(_ key: TypedMapKey<V>) {
        lock.lock()
        defer { lock.unlock() }
        
        entries.removeValue(forKey: key)
    }

    func get<V>(_ key: TypedMapKey<V>) -> V? {
        lock.lock()
        defer { lock.unlock() }

        deletePastTTL()
        
        if let v = entries[key]?.1 {
            return (v as! V)
        }
        return nil
    }

    private func deletePastTTL() {
        entries
            .filter { -$0.value.0.timeIntervalSinceNow > ttl }
            .forEach { entries.removeValue(forKey: $0.key) }
    }
}

struct TypedMapKey<ValueType> : Hashable, Sendable {
    let id = UUID()
}
