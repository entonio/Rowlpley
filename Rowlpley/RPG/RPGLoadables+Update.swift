//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI
import OSLog

extension RPGLoadables {
    func update() async throws {
        try await update(systemId: "OP")
    }

    private func update(systemId: String) async throws {
        let type = try RPGSystemType(systemId)
        let index = RPGSystemType.allCases.firstIndex(of: type)!
        let chunk = "00\(index  + 1)"
        let url = URL(string: "https://tulimonstro.net/loadables/loadable.\(chunk)")!

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.timeoutIntervalForResource = 3

        let (data, _) = try await URLSession(configuration: config).data(from: url)

        let fileManager = FileManager.default
        let mask = Bundle.main.locate(path: "Launch.jpeg")!
        let checksum = try Data(contentsOf: URL(filePath: mask)).checksum()
        let archive = try data.validate(using: checksum)

        let store = fileManager.cache(path: "Loadables/Systems/\(systemId)")
        try fileManager.createDirectory(atPath: store, withIntermediateDirectories: true)
        try archive.files().forEach {
            let path = "\(store)/\(URL(filePath: $0.path).lastPathComponent)"
            guard fileManager.createFile(
                atPath: path,
                contents: $0.data
            ) else {
                throw IOError("Could not write [\(path)]")
            }
        }
    }
}
