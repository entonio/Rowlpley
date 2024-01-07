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
