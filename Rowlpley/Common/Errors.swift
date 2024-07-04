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

struct UnexpectedValueError<T> : Error, CustomStringConvertible, CustomDebugStringConvertible {
    private let value: T
    private let options: (any Collection<T>)?

    init(_ value: T) {
        self.value = value
        self.options = nil
    }

    init(_ value: T, _ options: any Collection<T>) {
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

struct UnusableValueError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    private let value: Any
    private let context: Any

    init(_ value: Any, for context: Any) {
        self.value = value
        self.context = context
    }

    var description: String { "Unusable value [\(value)] for context [\(context)]" }
    var debugDescription: String { description }
}

struct ConversionError<S, T> : Error, CustomStringConvertible, CustomDebugStringConvertible {
    private let source: S
    private let target: T.Type
    private let options: (any Collection<T>)?

    init(_ source: S, _ target: T.Type) {
        self.source = source
        self.target = target
        self.options = nil
    }

    init(_ source: S, _ options: any Collection<T>) {
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
