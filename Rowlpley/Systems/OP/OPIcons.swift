//
// Copyright © 2024 Antonio Pedro Marques. All rights reserved.
//

import SwiftUI

extension OPEffect: WithIcon {
    var icon: String {
        switch self {
        case .red:       "🔴"
        case .black:     "⚫️"
        case .purple:    "🟣"
        case .gold:      "🟠"
        case .white:     "⚪️"
        case .blue:      "🔵"
        case .mental:    "😨"
        case .chemical:  "🧪"
        case .cold:      "🧊"
        case .fire:      "🔥"
        case .impact:    "🏏"
        case .piercing:  "🪡"
        case .cutting:   "✂️"
        case .ballistic: "🔫"
        }
    }
}

extension OPProficiencyTag: WithIcon {
    var icon: String {
        switch self {
        case .weapons:     "🔫"
        case .protections: "👷"
        case .light:       "🪽"
        case .simple:      "👍"
        case .tactical:    "🤔"
        case .heavy:       "🏋️"
        case .melee:       "🤼"
        case .shooting:    "🏹"
        case .fire:        "🔫"
        case .oneHanded:   "🍺"
        case .twoHanded:   "🍻"
        }
    }
}

extension OPItemDomain: WithIcon {
    var icon: String {
        switch self {
        case .medicine:   "🧑‍⚕️"
        case .profession: "🧰"
        case .documents:  "📝"
        }
    }
}
