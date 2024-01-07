//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import UIKit
import QuickLookThumbnailing

struct StoredCharacter: Decodable {
    let icon: StoredImage?
}

struct StoredImage: Decodable {
    let data: Data
}

class ThumbnailProvider: QLThumbnailProvider {

    lazy var rowlpcDefaultIconURL = Bundle.main.url(
        forResource: "rowlpc2",
        withExtension: "jpeg",
        subdirectory: "DefaultIcons/rowlpc"
    )!

    lazy var rowlpcDefaultIcon = UIImage(contentsOfFile: rowlpcDefaultIconURL.path(percentEncoded: false))!

    override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {
        guard let file = try? Data(contentsOf: request.fileURL) else {
            return handler(nil, nil)
        }

        return switch request.fileURL.pathExtension {
        case "rowlpc": rowlpcThumbnail(for: file, request, handler)
        default: handler(nil, nil)
        }
    }

    func rowlpcThumbnail(for file: Data, _ request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {

        guard let character = try? JSONDecoder().decode(StoredCharacter.self, from: file) else {
            return handler(nil, nil)
        }

        guard let data = character.icon?.data,
              let image = UIImage(data: data)
        else {
            return handler(QLThumbnailReply(
                imageFileURL: rowlpcDefaultIconURL), nil)
        }

        draw(image: image, logo: rowlpcDefaultIcon, request, handler)
    }

    func draw(image: UIImage, logo: UIImage, _ request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {

        let thumbnail = CGRect(origin: .zero, size: request.maximumSize)
        
        let tag = thumbnail.tile(total: 11, count: 2.5, indexX: 1, indexY: -1)

        let logoArea = tag.inner(ratio: logo.size, alignment: (.start, .end))

        let imageArea = thumbnail.inner(ratio: image.size, alignment: (.center, .center))

        let background = image.averageColor

        handler(QLThumbnailReply(contextSize: request.maximumSize) {
            if let background {
                background.setFill()
                UIGraphicsGetCurrentContext()?.fill([thumbnail])
            }
            image.draw(in: imageArea)
            logo.draw(in: logoArea)
            return true
        }, nil)
    }
}
