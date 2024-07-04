//
// Adapted from https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-dynamic-type-with-a-custom-font
//

import SwiftUI

extension Font {
    public static func system(_ contentSizeCategory: ContentSizeCategory, size: CGFloat, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return system(size: scaledSize, weight: weight, design: design)
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct DynamicFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    var name: String?
    var size: CGFloat

    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        if let name {
            return content.font(.custom(name, size: scaledSize))
        } else {
            return content.font(.system(size: scaledSize))
        }
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    func font(size: CGFloat) -> some View {
        modifier(DynamicFont(name: nil, size: size))
    }

    func font(name: String, size: CGFloat) -> some View {
        modifier(DynamicFont(name: name, size: size))
    }
}
