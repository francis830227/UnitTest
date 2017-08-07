enum RequestError: Error {
    case notFound(description: String)
    case badRequest(description: String)
}

func validateResponse(statusCode: Int) throws -> String {
    switch statusCode {
    case 200...299:
        print("Welcome! Francis.")
        return "Welcome! Francis."
    case 404:
        throw RequestError.notFound(description: "404 Not Found.")
    default:
        throw RequestError.badRequest(description: "Out Of Range.")
    }
}


func connectServer(number: Int) {
    do {
        try validateResponse(statusCode: number)
        
    } catch RequestError.notFound(let description) {
        print(description)
    } catch RequestError.badRequest(let description) {
        print(description)
    } catch {
        print("another error")
    }
}

connectServer(number: 404)
connectServer(number: 201)
connectServer(number: 500)
connectServer(number: 299)
connectServer(number: 101)


