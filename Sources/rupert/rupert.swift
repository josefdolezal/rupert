import Foundation

// MARK: Validation result
public enum ValidationResult<Value>: CustomStringConvertible {
    case success(Value)
    case failure(Error)

    public var description: String {
        switch self {
        case let .success(value): return "\(value)"
        case let .failure(error): return error.localizedDescription
        }
    }
}

// MARK: Result binding

public func validate<InputValue, OutputValue>(_ a: ValidationResult<InputValue>, _ f: (InputValue) -> ValidationResult<OutputValue>) -> ValidationResult<OutputValue> {
    switch a {
    case let .success(x): return f(x)
    case let .failure(error): return .failure(error)
    }
}

// MARK: Validation chaining operator

public func >>= <InputValue, OutputValue>(_ a: ValidationResult<InputValue>, _ f: (InputValue) -> ValidationResult<OutputValue>) -> ValidationResult<OutputValue> {
    return validate(a, f)
}
