//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation
import SwiftUI

struct LoadingView: View {

    @EnvironmentObject var loadables: RPGLoadables

    @State var retrying = false

    var body: some View {
        GeometryReader { g in
            ZStack {
                Image(uiImage: UIImage(named: "Launch.jpeg")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    // without this, the image would stretch the container, and not even be correctly centered
                    .frame(width: g.size.width, height: g.size.height)
                    .scaledToFill()

                if let statusMessage = loadables.status.message {
                    Text(statusMessage)
                        .multilineTextAlignment(.center)
                        .font(.headline.bold())
                        .padding(32)
                        .background(UIColor.systemGroupedBackground.color.opacity(0.8))
                        .foregroundStyle(UIColor.label.color.opacity(0.9))
                        .clipShape(.rect(cornerRadius: 16))
                }

                if retrying || loadables.status == .cancelled {
                    Button {
                        if !retrying { retrying = true }
                        loadables.reset()
                    } label: {
                        Text("Retry")
                    }
                    .disabled(loadables.status != .cancelled)
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
}
