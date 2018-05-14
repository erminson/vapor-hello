//
//  LoginRequest.swift
//  App
//
//  Created by Lev Erminson on 09.05.2018.
//

import Vapor

struct LoginRequest: Content {
    var email: String
    var password: String
}
