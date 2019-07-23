// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "swift-log-format-and-pipe",
    products: [
        .library(
            name: "LoggingFormatAndPipe",
            targets: ["LoggingFormatAndPipe"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "LoggingFormatAndPipe",
            dependencies: ["Logging"]),
        .testTarget(
            name: "LoggingFormatAndPipeTests",
            dependencies: ["LoggingFormatAndPipe", "Logging"]),
    ]
)
