import Foundation
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

let jsonObject: [String: Any] = [
                                    "id": 123.5,
                                    "first_name": "Mary",
                                    "last_name": "Smith"
                                ]

let data = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
let result = APIDataDecoder().decode(data: data, to: Record.self)

if let record = result.value {
    print(record)
} else {
    print("No record")
}
print(result.errors)
