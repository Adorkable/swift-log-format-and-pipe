//
//  FormatterTests.swift
//  LoggingFormatAndPipeTests
//
//  Created by Ian Grossberg on 7/23/19.
//

import XCTest
import Logging
import LoggingFormatAndPipe

final class FormatterTests: XCTestCase {
    func testFormatter(_ formatter: LoggingFormatAndPipe.Formatter) {
        let pipe = HistoryPipe()

        let logger = Logger(label: "test\(type(of: formatter))") { _ in
            return LoggingFormatAndPipe.Handler(
                formatter: formatter,
                pipe: pipe
            )
        }

        // TODO: fill in testing each case and combination :P

        logger.error("Test error message")
        XCTAssertEqual(pipe.formattedLogLine.count, 1)

        logger.info("Test info message")
        XCTAssertEqual(pipe.formattedLogLine.count, 2)
    }

    func testBasicFormatter() {
        self.testFormatter(BasicFormatter())
    }

    func testAppleFormatter() {
        self.testFormatter(BasicFormatter.apple)
    }

    func testAdorkableFormatter() {
        self.testFormatter(BasicFormatter.adorkable)
    }

    // TODO: test all formatters

    static var allTests = [
        ("testBasicFormatter", testBasicFormatter),
    ]
}
