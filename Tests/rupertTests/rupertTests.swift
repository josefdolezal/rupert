//
//  RupertTests.swift
//  rupert
//
//  Created by Josef Dolezal on 02/09/2017.
//
//

import XCTest
@testable import rupert

class RupertTests: XCTestCase {

    struct ExpectedError: Error, LocalizedError {
        var localizedDescription: String { return "ExpectedError" }
    }

    struct UnexpectedError: Error, LocalizedError {
        var localizedDescription: String { return "UnexpectedError" }
    }

    // Always success
    var successValidator: ((Bool) -> ValidationResult<Bool>)!
    // Always expected failure
    var expectedFailureValidator: ((Bool) -> ValidationResult<Bool>)!
    // Always unexpected failure
    var unexpectedFailureValidator: ((Bool) -> ValidationResult<Bool>)!

    override func setUp() {
        super.setUp()

        successValidator = { .success(!$0) }
        expectedFailureValidator = { _ in .failure(ExpectedError()) }
        unexpectedFailureValidator = { _ in .failure(UnexpectedError()) }
    }
    
    func testValidationFailsOnFailureInput() {
        let failureInput = ValidationResult<Bool>.failure(ExpectedError())
        let subject = validate(failureInput, successValidator)

        switch subject {
        case .success:
            XCTFail("Validation must return `failure` when `failure` is given as input.")
        case let .failure(error):
            XCTAssertTrue(error is ExpectedError, "Validation returns error from `failure` input.")
        }
    }

    func testValidationPassOnSuccessInput() {
        let successInput = ValidationResult.success(true)
        let subject = validate(successInput, successValidator)

        switch subject {
        case let .success(output):
            XCTAssertFalse(output, "Success output must be correctly transformed by validator.")
        case .failure:
            XCTFail("Validation must pass on success output.")
        }
    }

    func testValidationReturnsErrorFromValidationOnFailure() {
        let successInput = ValidationResult.success(true)
        let subject = validate(successInput, expectedFailureValidator)

        switch subject {
        case .success:
            XCTFail("Validation must fail if validator returns `failure`.")
        case let .failure(error):
            XCTAssertTrue(error is ExpectedError, "Returned error must be the one created by validator.")
        }
    }

    func testValidationReturnsFirstErrorOccurred() {
        let successInput = ValidationResult.success(true)
        let subject = validate(validate(successInput, expectedFailureValidator), unexpectedFailureValidator)

        switch subject {
        case .success:
            XCTFail("Validation must when at least one validation in chain fails.")
        case let .failure(error):
            XCTAssertTrue(error is ExpectedError, "Validation must return first error occurred in chain.")
        }
    }

    // (f(x) >>= g) == (validate(validate(f, x), g))
    func testValidationOperatorIsEqualToValidationFunction() {
        switch successValidator(true) >>= successValidator {
        case let .success(output):
            XCTAssertTrue(output, "Whole validation chain must be correctly applied on success input.")
        case .failure:
            XCTFail("Validation must pass for success inputs.")
        }

        switch successValidator(true) >>= expectedFailureValidator {
        case .success:
            XCTFail("Chain must fail if at least one error occures.")
        case let .failure(error):
            XCTAssertTrue(error is ExpectedError, "Error returned from chain must be equal to the one from failed validation.")
        }

        switch expectedFailureValidator(true) >>= unexpectedFailureValidator {
        case .success:
            XCTFail("Chain must fail if at least one error occures")
        case let .failure(error):
            XCTAssertTrue(error is ExpectedError, "Error returned from chain must be equal to the first error occured.")
        }
    }

    static var allTests: [(String, (RupertTests) -> () -> Void)] = [
        ("testValidationFailsOnFailureInput", testValidationFailsOnFailureInput),
        ("testValidationPassOnSuccessInput", testValidationPassOnSuccessInput),
        ("testValidationReturnsErrorFromValidationOnFailure", testValidationReturnsErrorFromValidationOnFailure),
        ("testValidationReturnsFirstErrorOccurred", testValidationReturnsFirstErrorOccurred),
        ("testValidationOperatorIsEqualToValidationFunction", testValidationOperatorIsEqualToValidationFunction)
    ]
}
