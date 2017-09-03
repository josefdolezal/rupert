//
//  GenericValidatorsTests.swift
//  rupert
//
//  Created by Josef Dolezal on 03/09/2017.
//
//

import XCTest
@testable import rupert

class GenericValidatorsTests: XCTestCase {

    enum TestEnumeration: String {
        case test
    }
    
    func testRequiredValidator() {
        var value: Bool? = true

        switch required(value) {
        case let .success(output):
            XCTAssertTrue(output, "Validator must not modify input value.")
        case .failure:
            XCTFail("Required validator must pass with non-nil values.")
        }

        value = nil

        switch required(value) {
        case .success:
            XCTFail("Required validator must fail on nil value.")
        case let .failure(error):
            XCTAssertTrue(error is RequiredFieldError)
        }
    }

    func testValueMatchValidator() {
        switch match(true)(true) {
        case let .success(output):
            XCTAssertTrue(output, "Match validator must not modify input value.")
        case .failure:
            XCTFail("Match validator must pass when input is equal to expected value.")
        }

        switch match(true)(false) {
        case .success:
            XCTFail("Match validator must fail if input is not equal to expected value.")
        case let .failure(error):
            XCTAssertTrue(error is FieldExactValueError)
        }
    }

    func testEnumerationTypeValidator() {
        switch type(TestEnumeration.self)("test") {
        case .success:
            break
        case .failure:
            XCTFail("Type validator must pass when input is valid raw value.")
        }

        switch type(TestEnumeration.self)("") {
        case .success:
            XCTFail("Type valdiator must fail if input is not valid raw value.")
        case let .failure(error):
            XCTAssertTrue(error is TypeMatchError<TestEnumeration>)
        }
    }

    static var allTests: [(String, (GenericValidatorsTests) -> () -> Void)] = [
        ("testRequiredValidator", testRequiredValidator),
        ("testValueMatchValidator", testValueMatchValidator),
        ("testEnumerationTypeValidator", testEnumerationTypeValidator)
    ]
}
