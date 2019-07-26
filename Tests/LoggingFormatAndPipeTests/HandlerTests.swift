//
//  HandlerTests.swift
//  LoggingFormatAndPipeTests
//
//  Created by Ian Grossberg on 7/23/19.
//

import XCTest
import Logging
import LoggingFormatAndPipe

final class HandlerTests: XCTestCase {
    func testPiping() {
        let pipe = HistoryPipe()
        let logger = Logger(label: "testPiping") { _ in
            return LoggingFormatAndPipe.Handler(
                formatter: BasicFormatter(),
                pipe: pipe
            )
        }

        logger.error("Test error message")
        XCTAssertEqual(pipe.formattedLogLine.count, 1)

        logger.info("Test info message")
        XCTAssertEqual(pipe.formattedLogLine.count, 2)
    }

    static var allTests = [
        ("testPiping", testPiping),
    ]
}
