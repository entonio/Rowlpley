//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

protocol ValueProvider<In, Out> {
    associatedtype In
    associatedtype Out
    func value(for source: In) -> Out
}

struct Block<In, Out> {
    private let block: (In) -> Out
    init(_ block: @escaping (In) -> Out) {
        self.block = block
    }
}

extension Block: ValueProvider {
    func value(for source: In) -> Out {
        block(source)
    }
}

extension KeyPath: ValueProvider {
    typealias In = Root
    typealias Out = Value

    func value(for source: In) -> Out {
        source[keyPath: self]
    }
}
