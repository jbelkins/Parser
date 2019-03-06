# LastMile
Robust decoding of model objects, tailored for use with JSON APIs

- Type-safe access to JSON from Swift
- Simple, clean syntax for decoding model objects
- Collects errors for abnormalities in the received JSON
- Built-in handling for Swift enumerations

## Syntax
Here is a sample model object:
```
struct Person {
    let id: Int
    let lastName: String
    let firstName: DemoSubStruct
    let phoneNumber: String?
    let gender: String?
}
```
`id`, `lastName`, and `firstName` are required fields.  `phoneNumber` and `gender` are optional.

Here is the JSON we will decode this object from:
```
{
    "id": 8675309,
    "first_name": "Mary",
    "last_name": "Smith",
    "phone_number": "(312) 555-1212",
    "hair_color": 7.5
}
```

And here is an `APIDecodable` extension for `Person` that will create a new instance:
```
extension Person: APIDecodable {

    init?(from decoder: APIDecoder) {
        // 1a
        let id =          decoder["id"]           --> Int.self
        let firstName =   decoder["first_name"]   --> String.self
        let lastName =    decoder["last_name"]    --> String.self
        
        // 1b
        let phoneNumber = decoder["phone_number"] --> String?.self
        let gender =      decoder["gender"]       --> String?.self
        let hairColor =   decoder["hair_color"]   --> String?.self
        
        // 2
        guard decoder.succeeded else { return nil }
        
        // 3
        self.init(id: id!, firstName: firstName!, lastName: lastName!, gender: gender, hairColor: hairColor)
    }
}
```
There are three steps to this initializer:

1) The decoder is used to create all of the values required to initialize a `DemoStruct`.  Using one or more subscripts on the parser lets you safely access JSON subelements, then you use the `-->` operator with either a type that is (1a) `APIDecodable` or (1b) an optional `APIDecodable`.

2) The initializer fails by returning `nil` if `decoder.succeeded` is false.  This will happen whenever any non-optional value is not present.

3) Finally, the structure is initialized by calling the memberwise initializer.  Required values `id`, `firstName`, and `lastName` may be force-unwrapped safely if `decoder.succeeded` was true.

## Using

To parse a `DemoStruct` from a data object containing JSON received by HTTP:
```
    let parser = try? DataParser(data: data)
    let newStruct = parser?.parse(DemoStruct.self)
```
