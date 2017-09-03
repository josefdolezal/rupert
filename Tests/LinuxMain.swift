import XCTest
@testable import rupertTests

XCTMain([
    testCase(RupertTests.allTests),
    testCase(GenericValidatorsTests.allTests),
    testCase(StringValidatorsTests.allTests)
])
