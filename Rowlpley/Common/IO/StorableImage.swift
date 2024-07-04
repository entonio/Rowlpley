//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI
import SwiftData
import SimpleCodable

@Model
@Codable
class StorableImage: Codable {
    @Attribute(.externalStorage) private var data: Data
    private var key: UUID

    init?(_ data: Data) {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        self.key = UUID()
        self.data = data
        Self.cache.do { $0.setObject(uiImage, forKey: key.ns) }
    }
}

extension StorableImage {
    private static let cache = Locked(NSCache<NSUUID, UIImage>())

    var uiImage: UIImage {
        if let uiImage = Self.cache.do({ $0.object(forKey: key.ns) }) {
            return uiImage
        }
        guard let uiImage = UIImage(data: data) else {
            assertionFailure("Cannot convert data to UIImage, but could do it on init")
            return UIImage()
        }
        Self.cache.do { $0.setObject(uiImage, forKey: key.ns) }
        return uiImage
    }
}

extension Bundle {
    func storableImage(path: String) -> StorableImage {
        try! StorableImage(Data(contentsOf: URL(filePath: locate(path: path)!)))!
    }
}
