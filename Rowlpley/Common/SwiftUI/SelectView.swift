//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct SelectView<Label, SelectionValue, Data, Name, ID>: View where Label: View, SelectionValue: Hashable, Data: RandomAccessCollection, Name: Any, ID : Hashable {

    let selection: Binding<SelectionValue>
    let options: Data
    let nameProvider: (any ValueProvider<Data.Element, Name>)?
    let id: KeyPath<Data.Element, ID>
    let label: () -> Label

    var body: some View {
        Menu {
            Picker(selection: selection) {
                ForEach(options, id: id) { option in
                    if let nameProvider {
                        let name = nameProvider.value(for: option)
                        if let name = name as? LocalizedStringKey {
                            Text(name)
                                .tag(id)
                        } else {
                            Text("\(name)")
                                .tag(id)
                        }
                    } else {
                        Text("\(option)")
                            .tag(id)
                    }
                }
            } label: {}
        } label: {
            label()
        }
    }

    init(_ selection: Binding<SelectionValue>, options: Data, name: (any ValueProvider<Data.Element, Name>)? = nil, id: KeyPath<Data.Element, ID>, label: @escaping () -> Label) {
        self.selection = selection
        self.options = options
        self.nameProvider = name
        self.id = id
        self.label = label
    }
}

extension SelectView where ID == Data.Element.ID, Data.Element : Identifiable, Name == Void {
    init(_ selection: Binding<SelectionValue>, options: Data, label: @escaping () -> Label) {
        self.init(selection, options: options, name: nil, id: \Data.Element.id, label: label)
    }
}

extension SelectView where ID == Data.Element.ID, Data.Element : Identifiable {
    init(_ selection: Binding<SelectionValue>, options: Data, name: any ValueProvider<Data.Element, Name>, label: @escaping () -> Label) {
        self.init(selection, options: options, name: name, id: \Data.Element.id, label: label)
    }
}

extension SelectView where ID == Data.Element, Data.Element : Hashable, Name == Void {
    @_disfavoredOverload
    init(_ selection: Binding<SelectionValue>, options: Data, label: @escaping () -> Label) {
       self.init(selection, options: options, name: nil, id: \Data.Element.self, label: label)
    }
}

extension SelectView where ID == Data.Element, Data.Element : Hashable {
    @_disfavoredOverload
    init(_ selection: Binding<SelectionValue>, options: Data, name: any ValueProvider<Data.Element, Name>, label: @escaping () -> Label) {
       self.init(selection, options: options, name: name, id: \Data.Element.self, label: label)
    }
}
