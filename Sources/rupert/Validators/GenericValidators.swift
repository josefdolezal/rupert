//
//  GenericValidators.swift
//  rupert
//
//  Created by Josef Dolezal on 01/09/2017.
//
//

import Foundation

// MARK: Required field validator
public struct RequiredFieldError: Error, LocalizedError {
    public let errorDescription: String? = "This field is required."
}

public func required<T>(_ value: T?) -> ValidationResult<T> {
    if let value = value {
        return .success(value)
    }

    return .failure(RequiredFieldError())
}

// MARK: Field exact value validator
public struct FieldExactValueError: Error, LocalizedError {
    public let errorDescription: String? = "The given value does not match the expected value."
}

public func match<T: Equatable>(_ expected: T) -> (T) -> ValidationResult<T> {
    return { x in
        guard expected == x else {
            return .failure(FieldExactValueError())
        }

        return .success(x)
    }
}

// MARK: Enumeration field validator
public struct TypeMatchError<T>: Error, LocalizedError {
    public let type: T.Type
    public var errorDescription: String? { return "This field must have value of type `\(type)`." }
}

public func type<T: RawRepresentable>(_ enumType: T.Type) -> (T.RawValue) -> ValidationResult<T> {
    return { x in
        guard let value = enumType.init(rawValue: x) else {
            return .failure(TypeMatchError(type: enumType))
        }

        return .success(value)
    }
}
