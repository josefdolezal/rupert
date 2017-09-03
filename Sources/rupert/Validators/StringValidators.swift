//
//  StringValidators.swift
//  Rupert
//
//  Created by Josef Dolezal on 01/09/2017.
//
//

import Foundation

// MARK: String fixed length validator
public struct StringExactLengthError: Error, LocalizedError {
    public let length: Int
    public var errorDescription: String? { return "The value must have exactly \(length) characters." }
}

public func length(_ length: Int) -> (String) -> ValidationResult<String> {
    return { x in
        guard x.characters.count == length else {
            return .failure(StringExactLengthError(length: length))
        }

        return .success(x)
    }
}

// MARK: Format match field validator
public struct PatternMatchError: Error, LocalizedError {
    public let pattern: String
    public var errorDescription: String? { return "This field must match following pattern: `\(pattern)`." }
}

public func match(_ expression: NSRegularExpression) -> (String) -> ValidationResult<String> {
    return { x in
        if expression.matches(in: x, options: [], range: NSRange(location: 0, length: x.characters.count)).count > 0 {
            return .success(x)
        }

        return .failure(PatternMatchError(pattern: expression.pattern))
    }
}

// MARK: Minimal field length validator
public struct MinimalFieldLengthError: Error, LocalizedError {
    public let minimalLength: Int
    public var errorDescription: String? { return "This field must be at least \(minimalLength) characters long." }
}

public func minLength(_ length: Int) -> (String) -> ValidationResult<String> {
    return { x in
        if x.characters.count >= length {
            return .success(x)
        }

        return .failure(MinimalFieldLengthError(minimalLength: length))
    }
}
