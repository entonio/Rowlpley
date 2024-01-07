//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

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

struct UnexpectedValueError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    private let value: Any

    init(_ value: Any) {
        self.value = value
    }

    var description: String { "Unexpected value: [\(value)]" }
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
