# LoggingFormatAndPipe
**LoggingFormatAndPipe** provides a [Swift Logging API](https://github.com/apple/swift-log) Handler which allows you to customized both your log messages' formats as well as their destinations.

If you don't like the default log format change it to one you would like. If you want one destination to be formatted differently than your other destination you can with ease. Or send the same format to multiple destinations!

<p align="center">
    <a href="#installation">Installation</a> | <a href="#getting-started">Getting Started</a> | <a href="http://adorkable.github.io/swift-log-format-and-pipe/">Documentation</a>
</p>

## Installation

### SwiftPM

To use the **LoggingFormatAndPipe** library in your project add the following in your `Package.swift`:

```swift
.package(url: "https://github.com/adorkable/swift-log-format-and-pipe.git", .from("0.1.0")),
```


## Getting Started

`LoggingFormatAndPipe.Handler` expects both a `Formatter` and a `Pipe`

```swift
let logger = Logger(label: "example") { _ in 
    return LoggingFormatAndPipe.Handler(
        formatter: ...,
        pipe: ...
    )
}
```

### Format
There are a number of ways of customizing the format.

#### BasicFormatter
`BasicFormatter` allows you to set the sequence of `LogComponents`, a separator and automatically processes them for each new log message.

Suppose you want a special short log format with a timestamp, the level, the file it originated in, and the message itself:

```swift
let myFormat = BasicFormatter(
	[
		.timestamp, 
		.level,
		.file,
		.message
	]
)
```

To change the separator from a single space specify the separator parameter:

```swift
let myFormat = BasicFormatter(
	...,
	separator: "|"
)
```

To change the timestamp from the default:

```swift
let myDateFormat = DateFormatter()
myDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
let myFormat = BasicFormatter(
	...,
	timestampFormatter: myDateFormat
)
```

`BasicFormatter` also includes already setup static instances:

* `.apple` - [apple/swift-log](https://github.com/apple/swift-log) format
* `.adorkable` - Adorkable's standard format 😘

#### Implementing Formatter
You can also create your own `Formatter` conforming object by implementing:

* `var timestampFormatter: DateFormatter { get }`
* `func processLog(level: Logger.Level,
                    message: Logger.Message,
                    prettyMetadata: String?,
                    file: String, function: String, line: UInt) -> String`
                    
More formatters to come!

### Pipe

Pipes specify where your formatted log lines end up going to. Included already are:

* `LoggerTextOutputStreamPipe.standardOutput` - log lines to `stdout`
* `LoggerTextOutputStreamPipe.standardError` - log lines to `stderr`

More pipes to come!

#### Implementing Pipe 
You can also create your own `Pipe` conforming object by implementing:

* `func handle(_ formattedLogLine: String)`

Easy!

Now you've got your use-case formatted log lines traveling this way and then, what a charm 🖤

### API Documentation
For more insight into the library API documentation is found in the repo [here](http://adorkable.github.io/swift-log-format-and-pipe/)
