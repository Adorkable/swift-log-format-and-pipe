//
//  Pipe.swift
//  LoggingFormatAndPipe
//
//  Created by Ian Grossberg on 7/22/19.
//

import Foundation

public protocol Pipe {
    func handle(_ formattedLogLine: String)
}
