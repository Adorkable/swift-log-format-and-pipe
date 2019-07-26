//
//  LoggerTextOutputStreamPipe.swift
//  LoggingFormatAndPipe
//
//  Created by Ian Grossberg on 7/22/19.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import Darwin
#else
import Glibc
#endif

import Logging

/// A pipe for sending logs to a `TextOutputStream`
public struct LoggerTextOutputStreamPipe: Pipe {
    private let stream: TextOutputStream

    /// Default init
    /// - Parameter _: Our stream to pipe to
    public init(_ stream: TextOutputStream) {
        self.stream = stream
    }

    /// Our main log handling pipe method
    /// - Parameters:
    ///   - _: The formatted log to handle
    public func handle(_ formattedLogLine: String) {
        var stream = self.stream
        stream.write("\(formattedLogLine)\n")
    }
}

extension LoggerTextOutputStreamPipe {
    /// Pipe logs to Standard Output (stdout)
    public static var standardOutput: LoggerTextOutputStreamPipe {
        return LoggerTextOutputStreamPipe(StdioOutputStream.stdout)
    }

    /// Pipe logs to Standard Error (stderr)
    public static var standardError: LoggerTextOutputStreamPipe {
        return LoggerTextOutputStreamPipe(StdioOutputStream.stderr)
    }

}

/// Copied from swift-log:Logging.swift until it is made public
/// A wrapper to facilitate `print`-ing to stderr and stdio that
/// ensures access to the underlying `FILE` is locked to prevent
/// cross-thread interleaving of output.
public struct StdioOutputStream: TextOutputStream {
    /// File handler we're writing to
    public let file: UnsafeMutablePointer<FILE>

    /// Write to file
    public func write(_ string: String) {
        string.withCString { ptr in
            flockfile(file)
            defer {
                funlockfile(file)
            }
            _ = fputs(ptr, file)
        }
    }

    internal static let stderr = StdioOutputStream(file: systemStderr)
    internal static let stdout = StdioOutputStream(file: systemStdout)
}

// Prevent name clashes
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
let systemStderr = Darwin.stderr
let systemStdout = Darwin.stdout
#else
let systemStderr = Glibc.stderr!
let systemStdout = Glibc.stdout!
#endif
