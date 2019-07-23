import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HandlerTests.allTests),
        testCase(FormatterTests.allTests),
        testCase(LoggerTextOutputStreamPipeTests.allTests),
    ]
}
#endif
