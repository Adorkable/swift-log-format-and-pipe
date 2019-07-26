//
//  LogFormatAndPipeHandler.swift
//  LoggingFormatAndPipe
//
//  Created by Ian Grossberg on 7/22/19.
//
import Logging

/// Logging Format and Pipe's Logging Backend
public struct Handler: LogHandler {

    /// Default init
    /// - parameters:
    ///   - formatter: Formatter to format with
    ///   - pipe: PIpe to pipe to
    public init(formatter: Formatter, pipe: Pipe) {
        self.formatter = formatter
        self.pipe = pipe
    }

    /// Formatter we're formatting with
    public let formatter: Formatter

    /// PIpe we're piping to
    public let pipe: Pipe

    /// Log level specification, used by Logger to filter all log levels less severe then the specified
    public var logLevel: Logger.Level = .info

    /// Our main Logging Backend method
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
    /// Our Logging Backend metadata
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }

    /// Add, remove, or change the logging metadata.
    /// - parameters:
    ///    - metadataKey: The key for the metadata item
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
