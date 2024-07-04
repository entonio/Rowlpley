//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

extension Color {
    enum Colorable: CaseIterable {
        case numbers
        case vowels
    }

    static let numberColors = {
        (Array(0...9) + [1]).map {
            Color("numberColor\($0)")
        }
    }()

    static let vowelColors = {
        ["A", "E", "I", "O", "U", "W", "Y"]
            .flatMap { [$0, $0.lowercased()] }
            .mapping {
                Color("vowelColor\($0.uppercased())")
            }
    }()
}

extension Character {
    func color(_ colorable: Set<Color.Colorable> = Color.Colorable.allCases.toSet()) -> Color? {
        if colorable.contains(.numbers) {
            if let wholeNumberValue {
                return Color.numberColors[wholeNumberValue]
            }
        } else if colorable.contains(.vowels) {
            if isLetter {
                let c = String(self).folding(options: .diacriticInsensitive, locale: .current)
                return Color.vowelColors[c]
            }
        }
        return nil
    }
}

extension StringProtocol {
    func colorViews(_ colorable: Set<Color.Colorable> = Color.Colorable.allCases.toSet()) -> [Text] {
        reduce(into: [(Color?, String)]()) {
            let color = $1.color(colorable)
            if let previous = $0.last, previous.0 == color {
                $0.removeLast()
                $0.append((color, previous.1 + [$1]))
            } else {
                $0.append((color, String($1)))
            }
        }.map {
            if let color = $0.0 {
                Text($0.1).foregroundStyle(color)
            } else {
                Text($0.1)
            }
        }
    }
}

struct ColoredText: View {
    let runs: [Text]

    init<Value: StringProtocol>(_ text: Value, colorable: Set<Color.Colorable> = Color.Colorable.allCases.toSet()) {
        self.runs = text.colorViews(colorable)
    }

    var body: some View {
        MultiText(runs)
    }
}
