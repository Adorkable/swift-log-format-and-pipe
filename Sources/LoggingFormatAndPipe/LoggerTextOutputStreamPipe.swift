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

public struct LoggerTextOutputStreamPipe: Pipe {
    public static var standardOutput: LoggerTextOutputStreamPipe {
        return LoggerTextOutputStreamPipe(StdioOutputStream.stdout)
    }

    public static var standardError: LoggerTextOutputStreamPipe {
        return LoggerTextOutputStreamPipe(StdioOutputStream.stderr)
    }

    private let stream: TextOutputStream

    public func handle(_ formattedLogLine: String) {
        var stream = self.stream
        stream.write("\(formattedLogLine)\n")
    }

    internal init(_ stream: TextOutputStream) {
        self.stream = stream
    }
}

/// Copied from swift-log:Logging.swift until it is made public
/// A wrapper to facilitate `print`-ing to stderr and stdio that
/// ensures access to the underlying `FILE` is locked to prevent
/// cross-thread interleaving of output.
public struct StdioOutputStream: TextOutputStream {
    public let file: UnsafeMutablePointer<FILE>

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
