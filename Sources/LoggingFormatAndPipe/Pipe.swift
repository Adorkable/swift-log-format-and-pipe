//
//  Pipe.swift
//  LoggingFormatAndPipe
//
//  Created by Ian Grossberg on 7/22/19.
//

import Foundation

/// Log PIpe
public protocol Pipe {
    /// Pipe's chance to send a formatted line where it deems
    /// - Parameter _: The formatted log to handle
    func handle(_ formattedLogLine: String)
}
