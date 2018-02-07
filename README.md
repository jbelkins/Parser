# Parser
Robust parsing for JSON APIs

- Type-safe access to JSON from Swift
- Simple, clean syntax for initializing model objects
- Collects errors for abnormalities in the received JSON


Here is a sample model object:
```
struct DemoStruct {
    let id: Int
    let name: String
    let first: DemoSubStruct

    let description: String?
    var substruct: DemoSubStruct?
}
```
`id`, `name`, and `first` are required fields.  `description` and `substruct` are optionals.

Here is an extension to `DemoStruct` with a failable initializer that complies with the `Parseable` protocol.

Because `id`, `name`, and `first` are required, we want our `DemoStruct` initializer to fail if any of these are not present.  The presence or absence of `description` and `substruct` will not affect whether the creation of a DemoStruct succeeds or fails.

```
extension DemoStruct: Parseable {

    init?(parser: Parser) {
        // 1
        let id = parser["id"].required(Int.self)
        let name = parser["name"].required(String.self)
        let first = parser["substructs"][0].required(DemoSubStruct.self)
        let description = parser["description"].optional(String.self)
        let substruct = parser["substruct"].optional(DemoSubStruct.self)
        
        // 2
        guard parser.succeeded else { return nil }
        
        // 3
        self.init(id: id!, name: name!, first: first!, description: description, substruct: substruct)
    }
}
```
There are three steps within this initializer:

1) The parser is used to create all of the fields required to initialize a `DemoStruct`.  Using one or more subscripts on the parser lets you safely access JSON subelements, then you call either `.required(_:)` or `.optional(_:)` as appropriate for the optionality of the value you are parsing.  Both `.required(_:)` and `.optional(_:)` return an optional value of the passed type.

2) The initializer is made to fail if `parser.succeeded` is false.  This will happen whenever any of the `.required(_:)` calls returned a nil value.

3) Finally, the structure is initialized by calling the memberwise initializer.  Required values `id`, `name`, and `first` may be force-unwrapped safely if `parser.succeeded` was true, since it means all required values were non-nil.
