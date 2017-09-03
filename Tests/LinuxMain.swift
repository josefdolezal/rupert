import XCTest
@testable import RupertTests

XCTMain([
    testCase(RupertTests.allTests),
    testCase(GenericValidatorsTests.allTests),
    testCase(StringValidatorsTests.allTests)
])
