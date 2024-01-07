//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension CGRect {
    func tile(total: CGFloat, count: CGFloat, indexX: CGFloat, indexY: CGFloat) -> CGRect {
        tile(totalX: total, totalY: total, countX: count, countY: count, indexX: indexX, indexY: indexY)
    }

    func tile(totalX: CGFloat, totalY: CGFloat, countX: CGFloat, countY: CGFloat, indexX: CGFloat, indexY: CGFloat) -> CGRect {
        let stepX = size.width / totalX
        let stepY = size.height / totalY
        let offsetX = stepX * indexX
        let offsetY = stepY * indexY
        let sizeX = stepX * countX
        let sizeY = stepY * countY
        return CGRect(
            x: offsetX >= 0 ? offsetX : size.width + offsetX - sizeX,
            y: offsetY >= 0 ? offsetY : size.height + offsetY - sizeY,
            width: sizeX,
            height: sizeY
        )
    }

    func inner(ratio: CGSize, alignment: (x: Alignment, y: Alignment)) -> CGRect {
        AVMakeRect(aspectRatio: ratio, insideRect: self)
            .size.align(inside: self, alignment)
    }
}

extension CGSize {
    func align(inside outer: CGRect, _ alignment: (x: Alignment, y: Alignment)) -> CGRect {
        return CGRect(
            origin: outer.origin + CGPoint(
                x: alignment.x.position(self.width, inside: outer.width),
                y: alignment.y.position(self.height, inside: outer.height)
            ),
            size: self
        )
    }
}

extension CGPoint {
    static func + (lhs: Self, rhs: Self) -> Self {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

enum Alignment {
    case start
    case center
    case end
}

extension Alignment {
    func position(_ inner: CGFloat, inside outer: CGFloat) -> CGFloat {
        switch self {
        case .start:  0
        case .center: (outer - inner) / 2
        case .end:    outer - inner
        }
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { rendererContext in
            setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

