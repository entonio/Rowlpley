//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

extension DateFormatter {
    enum FormatStyle {
        case filenameShort
        case filenameComplete
    }

    convenience init(_ style: FormatStyle) {
        switch style {
        case .filenameShort: self.init(
            includeDate: true,
            dateSeparator: ".",
            dateTimeSeparator: "-",
            includeTime: true,
            timeSeparator: ".",
            includeSeconds: true,
            includeMillis: false,
            millisSeparator: "",
            includeTimeZone: false,
            timeZoneSeparator: "",
            timeZone: .current
        )
        case .filenameComplete: self.init(
            includeDate: true,
            dateSeparator: "-",
            dateTimeSeparator: "T",
            includeTime: true,
            timeSeparator: ".",
            includeSeconds: true,
            includeMillis: true,
            millisSeparator: ".",
            includeTimeZone: true,
            timeZoneSeparator: "",
            timeZone: .current
        )
        }
    }
    
    convenience init(
        includeDate: Bool,
        dateSeparator: String,
        dateTimeSeparator: String,
        includeTime: Bool,
        timeSeparator: String,
        includeSeconds: Bool,
        includeMillis: Bool,
        millisSeparator: String,
        includeTimeZone: Bool,
        timeZoneSeparator: String,
        timeZone: TimeZone
    ) {
        var format = ""
        if includeDate {
            format += "yyyy\(dateSeparator)MM\(dateSeparator)dd"
        }
        if includeDate && includeTime {
            format += "'\(dateTimeSeparator)'"
        }
        if includeTime {
            format += "HH\(timeSeparator)mm"
            if includeSeconds {
                format += "\(timeSeparator)ss"
                if includeMillis {
                    format += "\(millisSeparator)SSS"
                }
            }
            if includeTimeZone {
                format += "\(timeZoneSeparator)Z"
            }
        }

        self.init()
        self.dateFormat = format
        self.timeZone = timeZone
    }
}
