//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI
import WrappingHStack

extension WrappingHStack {
    enum Style {
        case spaced
    }

    init<A: View>(style: Style, alignment: HorizontalAlignment = .trailing, spacing: Spacing = .constant(10), lineSpacing: CGFloat = 8, @ViewBuilder content: @escaping () -> A) {
        switch style {
        case .spaced: self.init(alignment: alignment, spacing: spacing, lineSpacing: lineSpacing, content: content)
        }
    }

    init<Data: RandomAccessCollection, Content: View>(style: Style, alignment: HorizontalAlignment = .trailing, spacing: Spacing = .constant(10), lineSpacing: CGFloat = 8, _ data: Data, id: KeyPath<Data.Element, Data.Element> = \.self, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        switch style {
        case .spaced: self.init(data, id:id, alignment: alignment, spacing: spacing, lineSpacing: lineSpacing, content: content)
        }
    }
}
