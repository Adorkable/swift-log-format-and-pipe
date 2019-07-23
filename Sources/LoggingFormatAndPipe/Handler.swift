//
//  LogFormatAndPipeHandler.swift
//  LoggingFormatAndPipe
//
//  Created by Ian Grossberg on 7/22/19.
//
import Logging

public struct Handler: LogHandler {

    public init(formatter: Formatter, pipe: Pipe) {
        self.formatter = formatter
        self.pipe = pipe
    }

    public let formatter: Formatter

    public let pipe: Pipe

    public var logLevel: Logger.Level = .info

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    file: String, function: String, line: UInt) {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))

        let formattedMessage = self.formatter.processLog(level: level, message: message, prettyMetadata: prettyMetadata, file: file, function: function, line: line)
        self.pipe.handle(formattedMessage)
    }

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }
}
