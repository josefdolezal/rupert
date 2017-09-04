# Rupert [![Build Status](https://travis-ci.com/josefdolezal/rupert.svg?token=AxpSW7yys3aiQpPG9zMW&branch=master)](https://travis-ci.com/josefdolezal/rupert) 

Rupert is tiny yet mighty form validation library written purely in Swift.
With Rupert, you can now write type-safe declarative validators, which are highly reusable and easy to test.

## Table of Contents

* [Demo](#demo)
* [Installation](#installation)
* [Usage](#usage)
* [Validators](#validators)
  * [Pre-packed Validators](#pre-packed-validators)
  * [Creating New Validators](#creating-new-validators)
  * [Reusing Validators](#reusing-validators)
* [Contributors](#contributors-initial-idea)
* [License](#license)

## Demo

Will be added soon.

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file.
Note that Rupert currently supports only `PackageDescriptionV4` and is compatible with Swift 4.0 and greater.

```swift
.package(url: "https://github.com/josefdolezal/rupert", .upToNextMinor(from: "0.1.0"))
```

## Usage

```swift
import Rupert

// Create format validator
let emailFormat = try! NSRegularExpression(pattern: "<MAIL_REGEX>", options: [])

var userName: String? = /* ... */
var userEmail: String? = /* ... */

// Declare required format of inputs
let nameResult = required(userName) >>= length(8)
let emailResult = required(userEmail) >>= length(6) >>= match(emailFormat)

// Handle the validation result
switch nameResult {
case let .success(name):
    print("Your name is \(name)")
case let .failure(error):
    print("Validation failed: \(error)")
}
```

## Validators

The base component of Rupert are `Validators`.
`Validators` are simple pure functions focused on simple and type-safe validations.
Each of these functions takes validated value as input and returns either `ValidationResult.success(T)` or `ValidationResult<T>.failure(Error)` as its output.
Even though validators doesn't take `ValidationResult` as input, you don't have to unwrap `.success` associated value after each validation, the validation operator (`>>=`) does this for you.
For list of validators delivered with library, see [Pre-packed Validators](#pre-packed-validators) section.

### Pre-packed Validators

Out of the box, Rupert comes up bundled with a few validators.
To achieve *master validation combos*, chain validators with validation operator `>>=`.
Currently supported validators are:

| Name       | Description                                                                  |
|------------|------------------------------------------------------------------------------|
| `required` | Safely unwraps optional values, fails validation on `nil`.                   |
| `match`    | Checks if given value is equal to given reference.                           |
| `type`     | Checks if value may be converted into `RawRepresentable` (e.g. `enum` case). |
| `length`   | Input String must have specified length.                                     |
| `minLength`| Input String must be at least `n` characters long.                           |
| `match`    | Input string must match given `NSRegularExpression`.                         |

Rupert is currently limited to a very few functions - but you can create your own validators really easily :tada:.
See the [Creating New Validators](#creating-new-validators) for handy tips.

### Creating New Validators

Since library provides only basic validators, you usually will have to create your own (yay or nay?).
Follow these steps to make it right:

1) Determine what should input and output be - and be strict! If you want to validate that number is greater than `n`, create generic number validator first, then use validation operator to chain validators.
2) Create `Error` class/struct/enum and conform it to `Error` and `LocalizedError` protocols.
3) Write tests!
4) Consider reusing validators instead of creating new one (see [Reusing Validators](#reusing-validators)).

### Reusing Validators

While creating extensive apps, validation login may grew up to complex task.
With Rupert, you can easily chain simple validators and reuse it across the whole app.

Declare composite validator as new function:

```swift
// Declare shared validators
struct AppValidators {
    static let nameValidator: (String?) -> ValidationResult<String> = {
        return { x in
            required(x) >>= /* Custom validators */ >>= length(8)
        }
    }()

    static let emailValidator: (String?) -> ValidationResult<String> = { /* ... */}

    static let dateValidator: (String?) -> ValidationResult<String> = { /* ... */}
}

// Then use as follows
AppValidators.dateValidator(myTextField.text)
```

## Contributors, initial idea

Rupert is heavily inspired by [Saul Mora's talk 'Object-Oriented Functional Programming'](https://academy.realm.io/posts/altconf-saul-mora-object-orientated-functional-programming/).
The initial code was written by [Lukáš Hromadník](https://github.com/LukasHromadnik) and is available [here](https://bitbucket.org/snippets/LukasHromadnik/7Ee8gX).

## License

This repository is licensed under [MIT](LICENSE) license. See the [LICENSE](LICENSE) file for more informations.
