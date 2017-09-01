import Foundation

// MARK: Validation result
enum ValidationResult<Value>: CustomStringConvertible {
    case success(Value)
    case failure(Error)

    var description: String {
        switch self {
        case let .success(value): return "\(value)"
        case let .failure(error): return error.localizedDescription
        }
    }
}

// MARK: Result binding
precedencegroup LeftAssociative {
    associativity: left
}

infix operator >>=: LeftAssociative

func validate<InputValue, OutputValue>(_ a: ValidationResult<InputValue>, _ f: (InputValue) -> ValidationResult<OutputValue>) -> ValidationResult<OutputValue> {
    switch a {
    case let .success(x): return f(x)
    case let .failure(error): return .failure(error)
    }
}

func >>=<InputValue, OutputValue>(_ a: ValidationResult<InputValue>, _ f: (InputValue) -> ValidationResult<OutputValue>) -> ValidationResult<OutputValue> {
    return validate(a, f)
}
