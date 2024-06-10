//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct TrailingDivider: View {
    var body: some View {
        Divider()
            .padding(.leading, 100)
    }
}

struct IntOperatorView: View {
    @Binding var number: Int

    var body: some View {
        Text(number > 0 ? "+" : number < 0 ? "-" : " ")
            .frame(width: 16)
    }
}

struct WarningView: View {
    var condition: Binding<Bool>
    @State var warningDisplayedAtLeastOnce = false

    init(_ condition: Binding<Bool>) {
        self.condition = condition
    }

    var body: some View {
        if condition.wrappedValue {
            Text("⚠️")
                .onAppear {
                    warningDisplayedAtLeastOnce = true
                }
        } else if warningDisplayedAtLeastOnce {
            SelfDismissingView {
                Text("✅")
            }
        }
    }
}

struct LRStack<Left, Right> : View where Left : View, Right : View {
    let left: () -> Left
    let right: () -> Right

    init(@ViewBuilder _ left: @escaping () -> Left, @ViewBuilder and right: @escaping () -> Right) {
        self.left = left
        self.right = right
    }

    var body: some View {
        HStack {
            left()
            Spacer()
            right()
        }
    }
}

struct SelfDismissingView<Content> : View where Content : View {
    let content: () -> Content

    @State var displayContent = true

    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        if displayContent {
            content()
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.75).delay(0.45)) {
                        displayContent = false
                    }
                }
        }
    }
}

struct ConditionalView<Content>: View where Content: View {
    let show: Binding<Bool>
    let content: () -> Content

    var body: some View {
        if show.wrappedValue {
            content()
        }
    }
}

extension View {
    @ViewBuilder func toggleConditionalView(_ show: Binding<Bool>) -> some View {
        onTapGesture {
            withAnimation {
                show.wrappedValue.toggle()
            }
        }
    }
}
