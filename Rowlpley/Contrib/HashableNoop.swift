//
// From https://medium.com/@dhavalshreyas/ignore-variables-for-equatable-conformance-in-swift-2f489fab76d9
//

import Foundation

@propertyWrapper
struct EquatableNoop<Value>: Equatable {
    var wrappedValue: Value

    static func == (lhs: EquatableNoop<Value>, rhs: EquatableNoop<Value>) -> Bool {
        true
    }
}

@propertyWrapper
struct HashableNoop<Value: Equatable>: Hashable {
    var wrappedValue: Value

    init(wrappedValue value: Value) {
        self.wrappedValue = value
    }

    func hash(into hasher: inout Hasher) {}
}
