//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//
        
import SwiftUI

extension OPAttributeView {
    static var innerX: CGFloat { 84 }
    static var paddingX: CGFloat { 8 }
    static var outerX: CGFloat { paddingX + innerX + paddingX }
    static var spacingX: CGFloat { 24 }
}

extension View {
    func opFormula() -> some View {
        self.multilineTextAlignment(.trailing)
            //.offset(y: 1.5)
            .font(.opFormula)
    }

    func opNumber() -> some View {
        self.font(.opNumber)
            .frame(width: 24)
    }

    func opWideNumber() -> some View {
        self.font(.opNumber)
            .frame(width: 44)
    }

    func opAttributeSizing() -> some View {
        self.frame(width: OPAttributeView.innerX)
            .padding(.leading, OPAttributeView.paddingX)
            .padding(.trailing, OPAttributeView.paddingX)
    }

    func opOverlaySelect() -> some View {
        self
//        self.padding(.leading, 4)
//            .background(.background.opacity(0.6))
//            .cornerRadius(4)
    }

    func opLabel<Foreground: ShapeStyle, Background: ShapeStyle>(_ background: Foreground, foreground: Background = .white) -> some View {
        self.foregroundStyle(foreground)
            .font(.footnote)
            .bold()
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(Rectangle().fill(background).cornerRadius(16))
    }

    func opSkill() -> some View {
        self.opLabel(.pink.gradient.secondary)
    }

    func opProficiency(_ active: Bool) -> some View {
        if active {
            self.opLabel(.green.gradient)
        } else {
            self.opLabel(.green.mixing(0.75, of: .gainsboro)!.gradient, foreground: .offWhite)
        }
    }

    func opPower(_ active: Bool) -> some View {
        if active {
            self.opLabel(.teal.gradient)
        } else {
            self.opLabel(.gainsboro.gradient, foreground: .offWhite)
        }
    }
}

extension Font {
    static var opAttribute: Font { .title }
    static var opNumber: Font { .body.weight(.heavy) }
    static var opFormula: Font { .footnote }
}

extension Color {
    init(red: Int, green: Int, blue: Int) {
        self.init(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }
}

extension ShapeStyle where Self == Color {

    static var opSecondary: Color { .secondary }
    
    static var opSecondaryInput: Color { .accentColor.opacity(0.6) }

    static var opHitPoints: Color { .blue }
    static var opTemporaryHitPoints: Color { .pink }
    static var opEffortPoints: Color { .green }
    static var opSanity: Color { .purple }
    static var opDefense: Color { .indigo }

    static var opExtentBackground: Color { .gainsboro }
    
    static var opFormulaExpression: Color { .gray }
    static var opFormulaResult: Color { .primary }
    
    static var opZero: Color { .gainsboro }

    static func opPointsGain(_ value: Int) -> Color {
        .green.opacity(Double(value) / 10 * 0.5 + 0.5)
    }

    static func opPointsLose(_ value: Int) -> Color {
        .red.opacity(Double(value) / 10 * 0.5 + 0.5)
    }

    static func opAttribute(_ value: Int) -> Color {
        OPAttribute.range.fuzzyMap(value, to: [
            .gray,
            .teal,
            .orange,
            .green,
            .indigo,
            .pink,
        ]) ?? .primary
    }
    
    static func opSkillTraining(_ value: Int) -> Color {
        OPSkill.training.fuzzyMap(value, to: [
            .opZero,
            .pink,
            .purple,
            .blue,
        ]) ?? .primary
    }
    
    static func opSkillBonus(_ modifier: RPGModifier) -> Color {
        if let value = modifier.int() {
            return value > 5 ? .primary : Array(0...5).fuzzyMap(value, exactFirst: true, to: [
                .opZero,
                .teal,
                .orange,
                .green,
                .indigo,
                .pink,
            ]) ?? .primary
        } else {
            return .primary
        }
    }
}

extension OPNex {
    var color: Color {
        Color.numberColors.intermediateValue(percent: self.percent.percentFloat) ?? .primary
    }
}
