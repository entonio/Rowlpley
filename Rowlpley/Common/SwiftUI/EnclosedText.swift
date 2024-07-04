//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct LetterView<Foreground: ShapeStyle, Background: ShapeStyle> : View {

    let letter: String
    let foreground: Foreground
    let background: Background

    init(_ sourceKey: LocalizedStringKey, _ foreground: Foreground = .clear, _ background: Background = .clear) {
        self.init(sourceKey.key, foreground, background)
    }

    init(_ source: String, _ foreground: Foreground = .clear, _ background: Background = .clear) {
        self.letter = source.localized().first!.uppercased()
        self.foreground = foreground
        self.background = background
    }

    var body: some View {
        MarkView(letter, foreground, background)
    }
}

struct MarkView<Foreground: ShapeStyle, Background: ShapeStyle> : View {
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    let text: String
    let foreground: Foreground
    let background: Background

    init(_ textKey: LocalizedStringKey, _ foreground: Foreground = .clear, _ background: Background = .clear) {
        self.init(textKey.key, foreground, background)
    }

    init(_ text: String, _ foreground: Foreground = .clear, _ background: Background = .clear) {
        self.text = text
        self.foreground = foreground
        self.background = background
    }

    var body: some View {
        let hasForeground = foreground as? Color != Color.clear
        let hasBackground = background as? Color != Color.clear
        if hasForeground, hasBackground {
            Text(text)
                .font(.system(sizeCategory, size: 12).weight(.heavy))
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .foregroundStyle(foreground)
                .background(background)
                .cornerRadius(4)
        } else if hasForeground {
            Text(text)
                .font(.system(sizeCategory, size: 12).weight(.heavy))
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .foregroundStyle(foreground)
                .cornerRadius(4)
        } else if hasBackground {
            Text(text)
                .font(.system(sizeCategory, size: 12).weight(.heavy))
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(background)
                .cornerRadius(4)
        } else {
            Text(text)
                .font(.system(sizeCategory, size: 12).weight(.heavy))
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .cornerRadius(4)
        }
    }
}
