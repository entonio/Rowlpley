//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct OPAttributesView: View {
    @Binding var character: OPCharacter

    var body: some View {
        HStack {
            Spacer()
            LazyVGrid(columns: [GridItem(.adaptive(minimum: OPAttributeView.outerX))]) {
                OPAttributeView(character: $character, attribute:.AGI)
                OPAttributeView(character: $character, attribute:.FOR)
                OPAttributeView(character: $character, attribute:.INT)
                OPAttributeView(character: $character, attribute:.PRE)
                OPAttributeView(character: $character, attribute:.VIG)
                OPAttributesTotalView(character: $character)
            }
            .max(columns:3,
                width: OPAttributeView.outerX,
                spacing: OPAttributeView.spacingX)
            Spacer()
        }
    }
}

struct OPAttributeView: View {
    @Binding var character: OPCharacter
    var attribute: OPAttribute

    var binding: Binding<Int> {
        Binding(get: {
            character.attribute(attribute)
        }, set: {
            character.setAttribute(attribute, $0)
        })
    }

    var body: some View {
        SelectView(binding, options: OPAttribute.range) {
            LRStack {
                Text(attribute.label)
                    .font(.opAttribute)
                    .foregroundStyle(Color.primary)
            } and: {
                Text("\(binding.wrappedValue)")
                    .font(.opAttribute.bold())
                    .foregroundStyle(.opAttribute(binding.wrappedValue))
                    .frame(width: 18)
            }
        }
        .opAttributeSizing()
    }
}

struct OPAttributesTotalView: View {
    @Binding var character: OPCharacter
    @State var warningDisplayedAtLeastOnce = false

    var body: some View {
        LRStack {
            Text("Sum")
                .foregroundStyle(.opSecondary)
        } and: {
            ZStack {
                TextField("", value: $character.attributesTotal, format: .number)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.opSecondaryInput)

                WarningView(.constant(character.attributesTotal != character.attributesSum))
                    .font(.caption2)
                    .offset(x: 28)
            }
            .frame(width: 24)
        }
        .opAttributeSizing()
    }
}
