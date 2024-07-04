//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import SwiftUI

struct LoadingView: View {

    @EnvironmentObject var loadables: RPGLoadables

    @State private var retrying = false
    @State private var showStatusContext = false

    var body: some View {
        GeometryReader { g in
            ZStack {
                Image(uiImage: UIImage(named: "Launch.jpeg")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    // without this, the image would stretch the container, and not even be correctly centered
                    .frame(width: g.size.width, height: g.size.height)
                    .scaledToFill()

                let statusContext = loadables.status.context
                if let statusMessage = loadables.status.message {
                    Text(showStatusContext && statusContext != nil ?
                         "\(statusContext!)" : statusMessage )
                        .multilineTextAlignment(.center)
                        .font(.headline.bold())
                        .padding(32)
                        .background(UIColor.systemGroupedBackground.color.opacity(0.8))
                        .foregroundStyle(UIColor.label.color.opacity(0.9))
                        .clipShape(.rect(cornerRadius: 16))
                        .onTapGesture {
                            showStatusContext.toggle()
                        }
                }

                if retrying || loadables.status.cancelled != nil {
                    Button {
                        if !retrying { retrying = true }
                        loadables.reset()
                    } label: {
                        Text("Retry")
                    }
                    .disabled(loadables.status.cancelled == nil)
                    .buttonStyle(.borderedProminent)
                    .offset(y: 120)
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

extension RPGLoadables.Status {
    var message: LocalizedStringKey? {
        switch self {
        case .idle:      nil
        case .updating:  "Updating system files..."
        case .loading:   "Loading systems..."
        case .ready:     nil
        case .cancelled: "Could not load systems 🤕"
        }
    }

    var context: String? {
        switch self {
        case .idle:      nil
        case .updating:  nil
        case .loading:   nil
        case .ready:     nil
        case .cancelled(let error):
            error.description.nilIfEmpty
        }
    }
}
