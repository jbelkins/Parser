import Foundation
import PlaygroundSupport
import LastMile


// https://github.com/jbelkins/LastMile-iOS


// For this playground to run correctly,
// you may have to build the framework with
// command-B first.

struct Record {
    let id: Int
    let firstName: String
    let lastName: String?
}


extension Record: APIDecodable {

    init?(from decoder: APIDecoder) {
        let id = decoder["id"] --> Int.self
        let firstName = decoder["first_name"] --> String.self
        let lastName = decoder["last_name"] --> String?.self
        guard decoder.succeeded else { return nil }
        self.init(id: id!, firstName: firstName!, lastName: lastName)
    }
}

let validJSONObject: [String: Any] = [
    "id": 123,
    "first_name": "Mary",
    "last_name": "Smith"
]

tryParsing(name: "Valid", object: validJSONObject)


let validWithErrorJSONObject: [String: Any] = [
    "id": 123,
    "first_name": "Mary",
    "last_name": 456        // Last name is expected to be a String
]

tryParsing(name: "Valid, but with 1 error", object: validWithErrorJSONObject)


let invalidJSONObject: [String: Any] = [
    "id": 123.4,  // id is expected to be an Int
    // First name is a required field and is missing
    "last_name": "Jones"
]

tryParsing(name: "Invalid, with 2 errors", object: invalidJSONObject)


// Helper method
func tryParsing(name: String, object: Any) {
    let data = try! JSONSerialization.data(withJSONObject: object)
    let result = APIDataDecoder().decode(data: data, to: Record.self)

    print("~~~~~~~~~~~~~~~ \(name) ~~~~~~~~~~~~~~~")
    if let record = result.value {
        print("Parsed record: \(record)")
    } else {
        print("Nil record")
    }
    print("Errors: \(result.errors)")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print()
    print()
}
