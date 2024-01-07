//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

extension Data {
    struct FSEntry {
        let path: String
        let data: Data
    }

    enum FSType {
        case zip
    }

    typealias FSFilter = (_ path: String) -> Bool

    func files(packaging: FSType = .zip, filter: @escaping FSFilter = { _ in true }) throws -> [FSEntry] {
        switch packaging {
        case .zip: try unzip(filter: filter)
        }
    }
}
