//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

protocol StringIdProvider: Codable, Hashable {
    var id: StringId { get }
}

struct StringId: ExpressibleByStringLiteral, StringIdProvider {
    var id: StringId { self }

    let content: String

    init(stringLiteral: String) {
        self.content = stringLiteral
    }

    static let empty: Self = "N/A"
}

extension String {
    func stringId() -> StringId {
        StringId(stringLiteral: self)
    }
}
