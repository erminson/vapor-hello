//
//  AcronymController.swift
//  App
//
//  Created by Lev Erminson on 14.05.2018.
//

import Vapor

final class AcronymController {
    func create(_ req: Request) throws -> Future<Acronym> {
        return try req.content.decode(Acronym.self).flatMap(to: Acronym.self) { acronym in
            return acronym.save(on: req)
        }
    }
    
    func get(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).all()
    }

}
