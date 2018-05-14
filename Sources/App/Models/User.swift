//
//  User.swift
//  App
//
//  Created by Lev Erminson on 09.05.2018.
//

import Vapor
import FluentSQLite

final class User: SQLiteModel {
    var id: Int?
    var name: String
    var email: String?
    
    init(id: Int? = nil, name: String, email: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
    }
}

extension User: Content {}

extension User: Migration {}
