//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

extension Bundle {
    func locate(path: String) -> String? {
        let name = path.lastPathComponent
        let folder = String(path.dropLast(name.count + 1))
        return self.path(forResource: name, ofType: nil, inDirectory: folder)
    }
}

extension String {
    var lastPathComponent: String {
        URL(string: self)!.lastPathComponent
    }

    var pathExtension: String {
        URL(string: self)!.pathExtension
    }
}

extension FileManager {
    func cache(path: String) -> String {
        urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appending(path: path)
            .path()
    }

    func documents(path: String) -> String {
        urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: path)
            .path()
    }
}

