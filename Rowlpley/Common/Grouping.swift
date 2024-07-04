//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

extension Collection {
    func counted() -> Dictionary<Element, Int> where Element: Hashable {
        reduce(into: Dictionary<Element, Int>()) {
            $0[$1] = ($0[$1] ?? 0) + 1
        }
    }

    func counted<K1: Hashable>(by key1: KeyPath<Element, K1>) -> Dictionary<K1, Int> {
        reduce(into: Dictionary<K1, Int>()) {
            let k1 = $1[keyPath: key1]
            var c1 = $0[k1] ?? 0
            c1 += 1
            $0[k1] = c1
        }
    }
}

extension Sequence where Element: Hashable {
    func mapping<V>(to value: (Element) -> V) -> [Element: V] {
        mapping({ $0 }, to: value)
    }
}

extension Sequence {
    func mapping<K: Hashable, V>(_ key: (Element) -> K, to value: (Element) -> V) -> [K: V] {
        reduce(into: [K: V]()) {
            $0[key($1)] = value($1)
        }
    }
}

extension Sequence {
    func mapped<K1: Hashable>(by key1: KeyPath<Element, K1>, onDuplicateKey: ((K1, Element, Element, inout [K1: Element]) throws -> Void)? = nil) rethrows -> [K1: Element] {
        try mapped(\.self, by: key1, onDuplicateKey: onDuplicateKey)
    }

    func mapped<K1: Hashable, V>(_ value: KeyPath<Element, V>, by key1: KeyPath<Element, K1>, onDuplicateKey: ((K1, V, V, inout [K1: V]) throws -> Void)? = nil) rethrows -> [K1: V] {
        if let onDuplicateKey {
            try reduce(into: [K1: V]()) {
                let k1 = $1[keyPath: key1]
                let v = $1[keyPath: value]
                if let existing = $0[k1] {
                    try onDuplicateKey(k1, existing, v, &$0)
                } else {
                    $0[k1] = v
                }
            }
        } else {
            reduce(into: [K1: V]()) {
                $0[$1[keyPath: key1]] = $1[keyPath: value]
            }
        }
    }
}

extension Sequence {
    func grouped<K1: Hashable>(by key1: KeyPath<Element, K1>) -> [K1: [Element]] {
        grouped(\.self, by: key1)
    }

    func grouped<K1: Hashable, V>(_ value: KeyPath<Element, V>, by key1: KeyPath<Element, K1>) -> [K1: [V]] {
        reduce(into: [K1: [V]]()) {
            let k1 = $1[keyPath: key1]
            let v = $1[keyPath: value]
            var c1 = $0[k1] ?? []
            c1.append(v)
            $0[k1] = c1
        }
    }

    func grouped<K1: Hashable, K2: Hashable>(by key1: KeyPath<Element, K1>, _ key2: KeyPath<Element, K2>) -> [K1: [K2: [Element]]] {
        grouped(\.self, by: key1, key2)
    }

    func grouped<K1: Hashable, K2: Hashable, V>(_ value: KeyPath<Element, V>, by key1: KeyPath<Element, K1>, _ key2: KeyPath<Element, K2>) -> [K1: [K2: [V]]] {
        reduce(into: [K1: [K2: [V]]]()) {
            let k1 = $1[keyPath: key1]
            let k2 = $1[keyPath: key2]
            let v = $1[keyPath: value]
            var c1 = $0[k1] ?? [:]
            var c2 = c1[k2] ?? []
            c2.append(v)
            c1[k2] = c2
            $0[k1] = c1
        }
    }
}
