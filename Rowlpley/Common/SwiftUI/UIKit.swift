//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

extension Color {
    func sharper(_ percent: CGFloat = 0.10) -> Color {
        uiColor.sharper(percent).color
    }
}

extension UIColor {
    func sharper(_ percent: CGFloat = 0.10) -> UIColor {
        mixing(percent, of: .label) ?? .label
    }
}

extension Color {
    var uiColor: UIColor { UIColor(self) }
}

extension UIColor {
    var color: Color { Color(uiColor: self) }
}

extension Color {
    func resolvedColor(with colorScheme: ColorScheme) -> Color {
        uiColor.resolvedColor(with: colorScheme).color
    }
}
extension UIColor {
    func resolvedColor(with colorScheme: ColorScheme) -> UIColor {
        resolvedColor(with: .init(userInterfaceStyle: colorScheme.userInterfaceStyle))
    }
}

extension UIColor {
    var light: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .light))
    }

    var dark: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .dark))
    }
}

extension ColorScheme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: .light
        case .dark:  .dark
        @unknown default: .light
        }
    }
}
