//
//  LoggerTextOutputStreamPipeTests.swift
//  LoggingFormatAndPipeTests
//
//  Created by Ian Grossberg on 7/23/19.
//

import XCTest
import Logging
import LoggingFormatAndPipe

final class LoggerTextOutputStreamPipeTests: XCTestCase {
    func testStdout() {
        let logger = Logger(label: "testStdout") { _ in
            return LoggingFormatAndPipe.Handler(
            formatter: BasicFormatter(),
            pipe: LoggerTextOutputStreamPipe.standardOutput
            )
        }

        logger.error("Test error message")

        logger.info("Test info message")

        // Check the logs!
    }

    func testStderr() {
        let logger = Logger(label: "testStderr") { _ in
            return LoggingFormatAndPipe.Handler(
                formatter: BasicFormatter(),
                pipe: LoggerTextOutputStreamPipe.standardError
            )
        }

        logger.error("Test error message")

        logger.info("Test info message")

        // Check the logs!
    }

    static var allTests = [
        ("testStdout", testStdout),
        ("testStderr", testStderr)
    ]
}
