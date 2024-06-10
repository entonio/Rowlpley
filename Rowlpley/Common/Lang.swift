//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//
        
import Foundation

extension BinaryInteger {
    var sign: String? { self > 0 ? "+" : self < 0 ? "-" : nil }
}

extension Double {
    init(_ content: any Numeric) {
       if let content = content as? Int {
           self = .init(content)
       } else if let content = content as? Float {
           self = .init(content)
       } else {
           self = content as! Double
       }
    }
}

extension Double {
    var percentInt: Int {
        Int(self * 100)
    }
}

extension BinaryInteger {
    var percentFloat: Double {
        Double(self) / 100
    }
}

extension Comparable {
    func clamped(lowerBound: Self, upperBound: Self) -> Self {
        self < lowerBound ? lowerBound :
        self > upperBound ? upperBound :
        self
    }
}

extension String {
    var stableHash: Int {
        var hash = 7351
        for byte in utf8 {
            hash = Int(byte) + 127 * (hash & 0x00ffffffffffffff)
        }
        return hash
     }
}

extension Regex {
    func test(_ string: String) -> Bool {
        (try? firstMatch(in: string)) != nil
    }
}

extension Sequence where Element: StringProtocol {
    func lines() -> String {
        joined(separator: "\n")
    }
}

extension UUID {
    var ns: NSUUID {
        self as NSUUID
    }
}

protocol Positionable {
    var position: IndexPath { get set }
}

extension IndexPath {
    static let zero = IndexPath(row: 0, section: 0)
}
