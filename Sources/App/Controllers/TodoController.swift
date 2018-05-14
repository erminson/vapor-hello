import Vapor
import Crypto

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    ///
    func get(_ req: Request) throws -> Future<Todo> {
        let userId = try req.parameters.next(Int.self)
        print(userId)
        let todo = try Todo.find(userId, on: req)
        return todo ?? Todo(id: 1, title: "sdf")
    }
    
    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            let todo = todo.create(on: req)
            return todo.save(on: req)
        }
    }
    
    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}
