//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import ZIPFoundation

extension Data {
    func unzip(filter: @escaping FSFilter = { _ in true }) throws -> [FSEntry] {
        let archive = try Archive(data: self, accessMode: .read)
        return try archive
            .toArray()
            .lazy
            .filter { filter($0.path) }
            .map {
                var data = Data()
                _ = try archive.extract($0) {
                    chunk in data += chunk
                }
                return FSEntry(
                    path: $0.path,
                    data: data
                )
            }
    }
}
