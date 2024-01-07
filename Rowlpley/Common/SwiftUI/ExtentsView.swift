//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI

struct ExtentsViewExtent<Extent, Style>: Identifiable where Extent: Numeric, Style: ShapeStyle {
    let id = UUID()
    let extent: Extent
    let style: Style

    init(_ extent: Extent, _ style: Style) {
        self.extent = extent
        self.style = style
    }
}

struct ExtentsViewContext {
    static let groupedRow = Self(height: 4, offsetY: 20)

    let height: CGFloat
    let offsetY: CGFloat
}

struct ExtentsView<Content, Extent, Style> : View where Content: View, Extent: Numeric, Style: ShapeStyle {

    let context: ExtentsViewContext
    let extents: [ExtentsViewExtent<Extent, Style>]
    let content: () -> Content

    init(context: ExtentsViewContext, _ extents: [ExtentsViewExtent<Extent, Style>], content: @escaping () -> Content) {
        self.context = context
        self.extents = extents
        self.content = content
    }

    var body: some View {
        if let max = extents.last {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width)
                        .foregroundStyle(.clear)

                    Rectangle()
                        .frame(
                            width: geometry.size.width,
                            height: context.height
                        )
                        .foregroundStyle(max.style)
                        .offset(y: context.offsetY)

                    ForEach(extents.dropLast().reversed()) { extent in
                        Rectangle()
                            .frame(
                                width: geometry.size.width * Double(extent.extent) / Double(max.extent),
                                height: context.height
                            )
                            .foregroundStyle(extent.style)
                            .offset(y: context.offsetY)
                    }

                    content()
                }
            }
        } else {
            content()
        }
    }
}
