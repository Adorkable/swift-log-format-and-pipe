//
//  TestLogging.swift
//  LoggingFormatAndPipeTests
//
//  Created by Ian Grossberg on 7/22/19.
//

import Foundation
@testable import LoggingFormatAndPipe
import XCTest

internal class HistoryPipe: LoggingFormatAndPipe.Pipe {
    var formattedLogLine = [String]()

    func handle(_ formattedLogLine: String) {
        self.formattedLogLine.append(formattedLogLine)
    }
}
