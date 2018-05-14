import FluentSQLite
import Vapor
//import SQLite3
import Leaf

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.get("todos", Int.parameter, use: todoController.get)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    router.get("user") { req -> User in
        return User(name: "Vapor User",
                    email: "user@vapor.codes")
    }
    
    router.post("login") { req -> Future<HTTPStatus> in
        print("login")
        return try req.content.decode(LoginRequest.self).map(to: HTTPStatus.self) { loginRequest in
            print(loginRequest.email)
            print(loginRequest.password)
            return .ok
        }
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Hello \(name)"
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
    
    /// Users
    let userController = UserController()
    
    router.get("users", use: userController.list)
    router.post("users", use: userController.create)
    
    /// Acronyms
    let acronymController = AcronymController()
    
    router.post("api", "acronyms", use: acronymController.create)
}
