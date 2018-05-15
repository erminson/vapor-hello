//import FluentSQLite
import Vapor
import Leaf

import Fluent

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
    router.post("api", "acronyms", use: acronymController.create)
    router.get("api", "acronyms", use: acronymController.get)
    
    router.get("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try req.parameters.next(Acronym.self)
    }
    
    router.put("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try flatMap(to: Acronym.self,
                           req.parameters.next(Acronym.self),
                           req.content.decode(Acronym.self)) { acronym, updatedAcronyn in
                            acronym.short = updatedAcronyn.short
                            acronym.long = updatedAcronyn.long
                            
                            return acronym.save(on: req)
        }
    }
    
    router.delete("api", "acronyms", Acronym.parameter) { req -> Future<HTTPStatus> in
        return try req.parameters.next(Acronym.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    // Search Route
    router.get("api", "acronyms", "search") { req -> Future<[Acronym]> in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        return try Acronym.query(on: req).filter(\.short == searchTerm).all()
    }
    
    // Get First Acronym
    router.get("api", "acronyms", "first") { req -> Future<Acronym> in
        return Acronym.query(on: req).first().map(to: Acronym.self, { acronym in
            guard let acronym = acronym else { throw Abort(.notFound) }
            return acronym
        })
    }
    
    // Get Sorted Acronym's List
    router.get("api", "acronyms", "sorted") { req -> Future<[Acronym]> in
        return try Acronym.query(on: req).sort(\.short, .ascending).all()
    }
}
