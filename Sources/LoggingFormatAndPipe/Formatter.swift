//
//  Formatter.swift
//  LoggingFormatAndPipe
//
//  Created by Ian Grossberg on 7/22/19.
//

import Logging
import Foundation

public enum LogComponent {
    case timestamp

    case level
    case message
    case metadata
    case file
    case function
    case line

    case text(String)
    case group([LogComponent])

    static var allNonmetaComponents: [LogComponent] {
        return [
            .timestamp,
            .level,
            .message,
            .metadata,
            .file,
            .function,
            .line
        ]
    }
}

public protocol Formatter {
    var timestampFormatter: DateFormatter { get }

    func processLog(level: Logger.Level,
                    message: Logger.Message,
                    prettyMetadata: String?,
                    file: String, function: String, line: UInt) -> String

}

extension Formatter {
    public func processComponent(_ component: LogComponent, now: Date, level: Logger.Level,
                                  message: Logger.Message,
                                  prettyMetadata: String?,
                                  file: String, function: String, line: UInt) -> String {
        switch component {
        case .timestamp:
            return self.timestampFormatter.string(from: now)
        case .level:
            return "\(level)"
        case .message:
            return "\(message)"
        case .metadata:
            return "\(prettyMetadata.map { "\($0)" } ?? "")"
        case .file:
            return "\(file)"
        case .function:
            return "\(function)"
        case .line:
            return "\(line)"
        case .text(let string):
            return string
        case .group(let logComponents):
            return logComponents.map({ (component) -> String in
                self.processComponent(component, now: now, level: level, message: message, prettyMetadata: prettyMetadata, file: file, function: function, line: line)
            }).joined()
        }
    }
}

public struct BasicFormatter: Formatter {
    public let format: [LogComponent]
    public let seperator: String?
    public let timestampFormatter: DateFormatter

    static public var timestampFormatter: DateFormatter {
        let result = DateFormatter()
        result.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return result
    }

    init(_ format: [LogComponent] = LogComponent.allNonmetaComponents, seperator: String = " ", timestampFormatter: DateFormatter = BasicFormatter.timestampFormatter) {
        self.format = format
        self.seperator = seperator
        self.timestampFormatter = timestampFormatter
    }

    public func processLog(level: Logger.Level,
                           message: Logger.Message,
                           prettyMetadata: String?,
                           file: String, function: String, line: UInt) -> String {
        let now = Date()

        return self.format.map({ (component) -> String in
            return self.processComponent(component, now: now, level: level, message: message, prettyMetadata: prettyMetadata, file: file, function: function, line: line)
        }).filter({ (string) -> Bool in
            return string.count > 0
        }).joined(separator: self.seperator ?? "")
    }

    public static let apple = BasicFormatter(
        [
            .timestamp,
            .group([
                .level,
                .text(":"),
            ]),
            .message
        ]
    )

    public static let adorkable = BasicFormatter(
        [
            .timestamp,
            .level,
            .group([
                .file,
                .text(":"),
                .line
            ]),
            .function,
            .message,
            .metadata
        ],
        seperator: " ▶ "
    )
}
