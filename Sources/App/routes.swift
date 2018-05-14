//import FluentSQLite
import Vapor
import Leaf

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Hello \(name)"
    }

    router.post("login") { req -> Future<HTTPStatus> in
        print("login")
        return try req.content.decode(LoginRequest.self).map(to: HTTPStatus.self) { loginRequest in
            print(loginRequest.email)
            print(loginRequest.password)
            return .ok
        }
    }
    
    router.post(InfoData.self, at: "info") { (req, data) -> String in
        return "Hello \(data.name)"
    }
    
    router.post(InfoData.self, at: "info") { req, data -> InfoResponse in
        return InfoResponse(request: data)
    }
    
    router.get("view") { req -> Future<View> in
        return try req.view().render("welcome")
    }
    
    router.get("bonus") { req -> Future<View> in
        let person = Person(name: "Lev", age: 33)
        return try req.view().render("whoami", person)
    }
    
    /// Acronyms
    let acronymController = AcronymController()
    router.get("api", "acronyms", use: acronymController.get)
    router.post("api", "acronyms", use: acronymController.create)
}
