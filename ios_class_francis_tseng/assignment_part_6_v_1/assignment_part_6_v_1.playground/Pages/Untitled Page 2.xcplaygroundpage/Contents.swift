/*
struct Friend {
    let name: String
    let age: String
    let address: String?
}

enum FriendError: Error {
    case invalidData(discription: String)
}

func friend(from dict: [String : String]) throws -> Friend {
    guard let name = dict["name"] else {
        throw FriendError.invalidData(discription: "Invalid name value")
    }
    
    guard let name = dict["age"] else {
        throw FriendError.invalidData(discription: "Invalid age value")
    }
    
    let address = dict["address"]
    
    return Friend(name: name, age: age, address: address)
}
*/