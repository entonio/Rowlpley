//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

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
    typealias EV = ExtentsViewExtent<Extent, Style>

    let context: ExtentsViewContext
    let extents: [EV]
    let content: () -> Content

    init(context: ExtentsViewContext, _ extents: [ExtentsViewExtent<Extent, Style>], content: @escaping () -> Content) {
        self.context = context
        self.extents = extents
        self.content = content
    }

    func positioned(_ extents: [EV], from: CGFloat, to: CGFloat) -> [(origin: CGFloat, length: CGFloat, extent: EV)] {
        guard let last = extents.last else { return [] }
        let total = to - from
        var nextFrom = from
        return extents.map {
            let percent = (Double($0.extent) / Double(last.extent)).clamped(lowerBound: 0, upperBound: 1)
            let currentFrom = nextFrom
            let currentTo = total * percent
            nextFrom = currentTo
            return (origin: currentFrom, length: currentTo - currentFrom, extent: $0)
        }

    }

    var body: some View {
        if extents.hasContents {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    ForEach(positioned(extents, from: 0, to: geometry.size.width).enumerated().toArray(), id: \.offset) { (_, positioned) in
                        Rectangle()
                            .frame(
                                width: positioned.length,
                                height: context.height
                            )
                            .foregroundStyle(positioned.extent.style)
                            .offset(x: positioned.origin, y: context.offsetY)
                    }

                    content()
                }
            }
        } else {
            content()
        }
    }
}
