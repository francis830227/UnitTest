var profile = [String: Any]()

profile["name"] = ""
profile["age"] = 0
let address: String = ""
let city: String = ""
let zip: Int = 0
profile["addresses"] = [address, city, zip]

enum profileError: Error {
    case invalidData(description: String)
}

func getHeight(from dict: [String : Any]) throws -> Any {
    
    if dict["height"] != nil{
        guard let height = dict["height"]  else {
            throw profileError.invalidData(description: "Invalid")
        }
        return height
    }else{
        print("This key doesn't exist.")
        return 0
    }
}


let someOne = try getHeight(from: profile)


