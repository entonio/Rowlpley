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

extension AnyView {
    init(text value: Any) {
        switch value {
        case let key as LocalizedStringKey: self.init(Text(key))
        case let string as any StringProtocol: self.init(Text(string))
        case let anyView as AnyView: self = anyView
        case let view as any View: self.init(view)
        default: self.init(Text("\(value)"))
        }
    }
}

struct MultiText: View {
    let runs: [AnyView]

    init(_ runs: [Any]) {
        self.runs = runs.map {
            AnyView(text: $0)
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(runs.indices, id: \.self) {
                runs[$0]
            }
        }
    }
}

struct WarningView: View {
    var condition: Binding<Bool>
    @State private var warningDisplayedAtLeastOnce = false

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

struct TextInput: View {
    let titleKey: LocalizedStringKey
    let binding: Binding<String>

    @State private var editedValue: String?
    @FocusState var isFocused: Bool

    init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
        self.titleKey = titleKey
        self.binding = text
    }

    var body: some View {
        TextField(titleKey, text: Binding {
            editedValue ?? binding.wrappedValue
        } set: {
            editedValue = $0
        })
        .focused($isFocused)
        .onChange(of: isFocused) {
            if !isFocused, let editedValue, editedValue != binding.wrappedValue {
                binding.wrappedValue = editedValue
                self.editedValue = nil
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
    @ViewBuilder let content: () -> Content

    @State private var displayContent = true

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

struct MinusButton: View {
    let condition: Bool
    let prompt: LocalizedStringKey
    let action: () -> Void

    init(_ condition: Bool, _ prompt: LocalizedStringKey, action: @escaping () -> Void) {
        self.condition = condition
        self.prompt = prompt
        self.action = action
    }

    var body: some View {
        ConditionalPromptButton(condition: condition, prompt: prompt, action: action) {
            Image(systemName: "minus.circle")
        }
        .font(.body)
        .rowButton()
    }
}

struct PlusButton: View {
    let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle")
        }
        .font(.body)
        .rowButton()
    }
}

struct ConditionalPromptButton<Label: View> : View {
    let condition: Bool
    let prompt: LocalizedStringKey
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    @State private var showConfirmDelete = false

    var body: some View {
        if condition {
            Button {
                action()
            } label: {
                Image(systemName: "minus.circle")
            }
        } else {
            Button {
                showConfirmDelete = true
            } label: {
                Image(systemName: "minus.circle")
            }
            .foregroundStyle(.red)
            .alert(prompt, isPresented: $showConfirmDelete) {
                Button(role: .cancel, action: {}) {
                    Text("No")
                }

                Button(role: .destructive, action: action) {
                    Text("Yes")
                }
            }
        }
    }
}

struct ConditionalView<Content> : View where Content: View {
    let show: Binding<Bool>
    @ViewBuilder let content: () -> Content

    var body: some View {
        if show.wrappedValue {
            content()
        }
    }
}

extension View {
    @ViewBuilder func toggleWithAnimation(_ binding: Binding<Bool>) -> some View {
        onTapGesture {
            withAnimation {
                binding.wrappedValue.toggle()
            }
        }
    }
}

