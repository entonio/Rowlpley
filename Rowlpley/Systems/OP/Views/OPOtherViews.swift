//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI

struct OPNumberInput: View {
    let value: Binding<Int>
    let unit: String?

    init(value: Binding<Int>, unit: String? = nil) {
        self.value = value.copy
        self.unit = unit
    }

    var body: some View {
        if let unit {
            HStack(alignment: .firstTextBaseline, spacing: 0.5) {
                TextField("", value: value, format: .number)
                    .multilineTextAlignment(.trailing)
                    .opNumber()
                Text(unit)
                    .font(.opNumber)
            }
        } else {
            TextField("", value: value, format: .number)
                .multilineTextAlignment(.center)
                .opNumber()
        }
    }
}

struct OPFormulaView: View  {
    let expression: Any
    let result: Any
    let resultStyle: any ShapeStyle

    init(_ expression: Any, _ result: Any, _ resultStyle: (any ShapeStyle)? = nil) {
        self.expression = expression
        self.result = result
        if let resultStyle {
            self.resultStyle = resultStyle.opacity(0.8)
        } else {
            self.resultStyle = .opFormulaResult
        }
    }

    var body: some View {
        Text("\(Text("\(expression)").foregroundStyle(.opFormulaExpression))\(Text(" → ").foregroundStyle(resultStyle))\(Text("\(result)").foregroundStyle(resultStyle))")
            .opFormula()
    }
}
