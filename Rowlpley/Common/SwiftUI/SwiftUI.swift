//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI

extension View {
    func max(columns: Int, width: CGFloat, spacing: CGFloat) -> some View {
        let columns = CGFloat(columns)
        return self.frame(maxWidth: columns * width + (columns + 1) * spacing)
    }
}

extension View {
    func rowButton<Style: ShapeStyle>(_ style: Style) -> some View {
        self.buttonStyle(.borderless)
            .padding(0)
            .padding(.horizontal, 5)
            .font(.body.bold())
            .foregroundStyle(style)
    }
}

extension Binding {
    var copy: Self {
        Binding(get: {
            wrappedValue
        }, set: {
            wrappedValue = $0
        })
    }
}

extension Binding where Value == String {
    static func binding<T: AnyObject>(_ object: T, array: ReferenceWritableKeyPath<T, [String]>) -> Self {
        Binding(get: {
            object[keyPath: array].joined(separator: " ")
        }, set: {
            object[keyPath: array] = $0.components(separatedBy: .whitespacesAndNewlines)
        })
    }
}

enum GraphicalOrientation: Codable {
    case standard
    case alternative
    
    var opposite: GraphicalOrientation {
        switch self {
        case .standard: .alternative
        case .alternative: .standard
        }
    }
}

extension GraphicalOrientation {
    var traitsAlignment: HorizontalAlignment {
        switch self {
        case .standard: .trailing
        case .alternative: .leading
        }
    }

    func traitsLabels<Element: Any>(_ labels: [Element]...) -> [Element] {
        let labels = labels.flatMap{ $0 }
        return switch self {
        case .standard: labels
        case .alternative: labels.reversed()
        }
    }

    var pictureAlignment: Alignment {
        switch self {
        case .standard: .leading
        case .alternative: .trailing
        }
    }

    var pictureMask: some View {
        switch self {
        case .standard: LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .center, endPoint: .trailing)
        case .alternative: LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .leading, endPoint: .center)
        }
    }
}

extension View {
    func traitSelector(_ graphicalOrientation: GraphicalOrientation) -> some View {
        switch graphicalOrientation {
        case .standard:
            AnyView(HStack { Spacer(); self })
        case .alternative:
            AnyView(HStack { self; Spacer() })
        }
    }
}

enum StorableColorScheme: Int, Hashable, CaseIterable {

    case system
    case light
    case dark

    public var name: LocalizedStringKey {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    public var scheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}
