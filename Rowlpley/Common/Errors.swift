//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

struct ProcessingError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var debugDescription: String { description }
}

struct IOError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var debugDescription: String { description }
}

struct PreconditionError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var debugDescription: String { description }
}

struct UnexpectedValueError<T: Sendable, C: Collection<T>> : Error, CustomStringConvertible, CustomDebugStringConvertible where C: Sendable {
    private let value: T
    private let options: C?

    init(_ value: T) {
        self.value = value
        self.options = nil
    }

    init(_ value: T, _ options: C) {
        self.value = value
        self.options = options
    }

    var description: String {
        if let options {
            "Unexpected value: [\(value)] is not one of \(options)"
        } else {
            "Unexpected value: [\(value)]"
        }
    }
    var debugDescription: String { description }
}

struct UnusableValueError<V: Sendable, C: Sendable>: Error, CustomStringConvertible, CustomDebugStringConvertible {
    private let value: V
    private let context: C

    init(_ value: V, for context: C) {
        self.value = value
        self.context = context
    }

    var description: String { "Unusable value [\(value)] for context [\(context)]" }
    var debugDescription: String { description }
}

struct ConversionError<S: Sendable, T: Sendable, C: Collection<T>> : Error, CustomStringConvertible, CustomDebugStringConvertible  where C: Sendable {
    private let source: S
    private let target: T.Type
    private let options: C?

    init(_ source: S, _ target: T.Type) where C == Array<T> {
        self.source = source
        self.target = target
        self.options = nil
    }

    init(_ source: S, _ options: C) {
        self.source = source
        self.target = T.self
        self.options = options
    }

    var description: String {
        if let options {
            "Cannot convert [\(source)] to any of \(options)"
        } else {
            "Cannot convert [\(source)] to \(target)"
        }
    }
    var debugDescription: String { description }
}
