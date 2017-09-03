//
//  StringValidatorsTests.swift
//  Rupert
//
//  Created by Josef Dolezal on 03/09/2017.
//
//

import XCTest
@testable import Rupert

class StringValidatorsTests: XCTestCase {

    func testStringLengthValidator() {
        let reference = "test"
        switch length(4)(reference) {
        case let .success(output):
            XCTAssertEqual(output, reference, "String length validator must not modify input value.")
        case .failure:
            XCTFail("String length validator must pass when input has required length.")
        }

        switch length(4)("") {
        case .success:
            XCTFail("String length validator must fail when input length is different from required.")
        case let .failure(error):
            XCTAssertTrue(error is StringExactLengthError)
        }
    }

    func testMinimalStringLengthValidator() {
        let reference = "test"

        switch minLength(4)(reference) {
        case let .success(output):
            XCTAssertEqual(output, reference, "String minimal length validator must not modify output.")
        case .failure:
            XCTFail("String minimal length validator must pass when input has minimal requied length.")
        }

        switch minLength(3)(reference) {
        case let .success(output):
            XCTAssertEqual(output, reference, "String minimal length validator must not modify output.")
        case .failure:
            XCTFail("String minimal length validator must pass when input is longer than minimal required length.")
        }

        switch minLength(5)(reference) {
        case .success:
            XCTFail("String minimal length validator must fail if input is shorter than required length.")
        case let .failure(error):
            XCTAssertTrue(error is MinimalFieldLengthError)
        }
    }

    func testStringFormatMatchValidator() {
        let uppercaseRegex = try! NSRegularExpression(pattern: "^[A-Z]", options: [])
        let reference = "TEST"

        switch match(uppercaseRegex)(reference) {
        case let .success(output):
            XCTAssertEqual(output, reference, "String format validator must not modify input.")
        case .failure:
            XCTFail("String format validator must pass when input format is correct.")
        }

        switch match(uppercaseRegex)(reference.lowercased()) {
        case .success:
            XCTFail("String format validator must fail if input has incorrect format.")
        case let .failure(error):
            XCTAssertTrue(error is PatternMatchError)
        }
    }

    static var allTests: [(String, (StringValidatorsTests) -> () -> Void)] = [
        ("testStringLengthValidator", testStringLengthValidator),
        ("testMinimalStringLengthValidator", testMinimalStringLengthValidator),
        ("testStringFormatMatchValidator", testStringFormatMatchValidator)
    ]
}
