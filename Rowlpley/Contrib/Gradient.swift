//
// Adapted from https://www.hackingwithswift.com/forums/swiftui/how-to-pick-a-single-colour-within-a-gradient-based-on-a-value/5208
// which is based on https://stackoverflow.com/a/59996029/3505188
//

import UIKit
import SwiftUI

extension Array where Element == Color {
    func intermediateValue(percent: Double) -> Color? {
        switch percent {
        case 0: return first
        case 1: return last
        default:
            let values = intermediateValues(percent: percent)

            return values.first.uiColor
                .mixing(values.percent, of: values.second.uiColor)?.color
            ?? values.fallback
        }
    }
}

extension Array where Element: UIColor {
    func intermediate(percent: CGFloat) -> UIColor? {
        switch percent {
        case 0: return first
        case 1: return last
        default:
            let values = intermediateValues(percent: percent)

            return values.first
                .mixing(values.percent, of: values.second) 
            ?? values.fallback
        }
    }
}

extension Array {
    private func intermediateValues(percent: Double) -> (first: Element, second: Element, fallback: Element, percent: Double) {

        let approxIndex = percent * Double(count - 1)
        let firstIndex = Int(approxIndex.rounded(.down))
        let secondIndex = Int(approxIndex.rounded(.up))
        let fallbackIndex = Int(approxIndex.rounded())

        return (
            self[firstIndex],
            self[secondIndex],
            self[fallbackIndex],
            approxIndex - Double(firstIndex)
        )
    }
}

extension Color {
    func mixing(_ percent: Double, of second: Color) -> Color? {
        uiColor.mixing(percent, of: second.uiColor)?.color
    }
}

extension UIColor {
    func mixing(_ percent: CGFloat, of second: UIColor) -> UIColor? {
        if percent < 0 { return self }
        if percent > 1 { return second }
        
        let first = self.resolvedColor(with: .current)
        let second = second.resolvedColor(with: .current)

        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        guard first.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else {
            return nil
        }
        guard second.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else {
            return nil
        }

        return UIColor(red: CGFloat(r1 * (1 - percent) + r2 * percent),
                       green: CGFloat(g1 * (1 - percent) + g2 * percent),
                       blue: CGFloat(b1 * (1 - percent) + b2 * percent),
                       alpha: CGFloat(a1 * (1 - percent) + a2 * percent)
        )
    }
}
