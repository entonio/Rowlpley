//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let rowlpc = UTType(exportedAs: "net.tulimonstro.rowlpc", conformingTo: .data)
}

struct RowlPC {
    let name: String
    let text: String
}

extension RowlPC: FileDocument {
    static let readableContentTypes: [UTType] = [.rowlpc]
    static let writableContentTypes: [UTType] = [.rowlpc]

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.name = configuration.file.filename ?? UUID().uuidString
        self.text = String(decoding: data, as: UTF8.self)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let file = FileWrapper(regularFileWithContents: Data(text.utf8))
        file.filename = name
        return file
    }
}
