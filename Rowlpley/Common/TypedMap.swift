//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

// This is not thread-safe. Do not rely on it for thread-safe use.
class TypedMap {
    private var entries: [AnyHashable: (Date, Any)] = [:]

    private var ttl: TimeInterval
    
    init(ttl: TimeInterval) {
        self.ttl = ttl
    }

    func put<V>(_ key: TypedMapKey<V>, _ value: V) {
        entries[key] = (Date.now, value)
    }

    func delete<V>(_ key: TypedMapKey<V>) {
        entries.removeValue(forKey: key)
    }

    func get<V>(_ key: TypedMapKey<V>) -> V? {
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

class TypedMapKey<ValueType>: Hashable {
    let id = UUID()

    static func == (lhs: TypedMapKey<ValueType>, rhs: TypedMapKey<ValueType>) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
