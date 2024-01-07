//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

extension JSONEncoder {
    public func encode<V: Encodable>(_ value: V, format: OutputFormatting) throws -> String {
        outputFormatting = format
        return String(
            data: try encode(value),
            encoding: .utf8
        )!
    }
}

extension JSONDecoder {
    public func decode<T: Decodable>(string: String, to type: T.Type) throws -> T  {
        try decode(
            type,
            from: string.data(using: .utf8)!
        )
    }
}
