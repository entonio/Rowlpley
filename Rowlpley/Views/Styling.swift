//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var offWhite: Color { .white.opacity(0.6) }
    static var gainsboro: Color { .gray.opacity(0.3) }
}

extension CGFloat {
    static let characterIconSize: Self = 34
}

extension Color {
    static let numberColors = {
        (Array(0...9) + [0]).map {
            Color("numberColor\($0)")
        }
    }()
}
