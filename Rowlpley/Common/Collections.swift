//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

extension Collection {
    var hasContents: Bool { !isEmpty }

    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}

extension Collection {
    func counted() -> [Element: Int] where Element: Hashable {
        reduce(into: [Element: Int]()) {
            $0[$1] = ($0[$1] ?? 0) + 1
        }
    }

    func counted<K1: Hashable>(by key1: KeyPath<Element, K1>) -> [K1: Int] {
        reduce(into: [K1: Int]()) {
            let k1 = $1[keyPath: key1]
            var c1 = $0[k1] ?? 0
            c1 += 1
            $0[k1] = c1
        }
    }
}

extension Collection {
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
                let k1 = $1[keyPath: key1]
                let v = $1[keyPath: value]
                $0[k1] = v
            }
        }
    }
}

extension Collection {
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

extension Sequence {
    @inlinable func reduce<T, U>(_ first: T, _ second: U, _ updateAccumulatingResult: (Element, inout T, inout U) throws -> ()) rethrows -> (T, U) {
        var first = first
        var second = second
        try forEach {
            try updateAccumulatingResult($0, &first, &second)
        }
        return (first, second)
    }
}

extension Sequence {
    func toArray() -> [Element] {
        Array(self)
    }
}

extension Sequence where Element: Hashable {
    func toSet() -> Set<Element> {
        Set(self)
    }
}

extension Sequence {
    public static func + (lhs: Self, rhs: Self) -> [Self.Element] {
        var result: [Self.Element] = []
        result.append(contentsOf: lhs)
        result.append(contentsOf: rhs)
        return result
    }

    public static func - (lhs: Self, rhs: Self) -> [Self.Element] where Self.Element: Equatable {
        lhs.filter { !rhs.contains($0) }
    }
}

extension Set {
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.union(rhs)
    }
}

extension Set {
    func intersects(_ other: Set) -> Bool {
        count < other.count
        ? contains { other.contains($0) }
        : other.contains { contains($0) }
    }
}

extension Set {
    func inMissingSets(_ sets: Set<Element>...) -> [Element] {
        sets.flatMap {
            intersects($0) ? [] : $0.toArray()
        }
    }
}

extension Dictionary {
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.merging(rhs) { $1 }
    }
}

extension Dictionary {
    struct KeySortComparator<KeyComparator: SortComparator<Key>>: SortComparator {
        var comparator: KeyComparator
        var order: SortOrder {
            get { comparator.order }
            set { comparator.order = newValue }
        }
        func compare(_ lhs: Dictionary<Key, Value>.Element, _ rhs: Dictionary<Key, Value>.Element) -> ComparisonResult {
            comparator.compare(lhs.key, rhs.key)
        }
    }

    public func sorted<Comparator>(usingKeys comparator: Comparator) -> [Self.Element] where Comparator : SortComparator, Self.Key == Comparator.Compared {
        sorted(using: KeySortComparator(comparator: comparator))
    }

    public func sorted<S, Comparator>(usingKeys comparators: S) -> [Self.Element] where S : Sequence, Comparator : SortComparator, Comparator == S.Element, Self.Key == Comparator.Compared {
        sorted(using: comparators.lazy.map(KeySortComparator.init))
    }
}

extension Array {
    func element(modulo index: Int) -> Element {
        self[abs(index) % count]
    }
}

extension Array {
    func every(_ position: Int, of modulo: Int) -> Self {
        enumerated()
            .lazy
            .filter {
                $0.offset % modulo == position - 1
            }
            .map { $0.element }
    }
}

extension Array where Element: Comparable {
    func fuzzyIndex(of value: Element) -> Int? {
        if isEmpty {
            return nil
        }
        if last! < value {
            return count - 1
        }
        for i in 0..<(count-1) {
            let candidate = self[i]
            if candidate < value {
                continue
            }
            if value < candidate {
                if i > 0 {
                    return i - 1
                }
            }
            return i
        }
        return count - 1
    }

    func fuzzyMap<T>(_ value: Element, exactFirst: Bool = false, to mapping: Array<T>) -> T? {
        if exactFirst, first == value {
            return mapping.first
        }

        guard var index = fuzzyIndex(of: value) else {
            return nil
        }

        if exactFirst, index == 0 {
            index = 1
        }

        return mapping.fuzzy(at: index, count: count, exactFirst: exactFirst)
    }
}

extension Array {
    func fuzzy(at index: Int, count total: Int, exactFirst: Bool = false) -> Element? {
        if index < 0 || index >= total || isEmpty {
            return nil
        }
        if total == count {
            return self[index]
        }
        if index == 0 || index == count - 1 {
            return self[index]
        }
        var proportional = Int(Double(index * count) / Double(total))
        if exactFirst, proportional == 0, count > 1 {
            proportional = 1
        }
        return self[proportional]
    }
}
