//
//  File.swift
//  
//
//  Created by evhn on 20.02.2024.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {

        let group = routes.grouped("\(User.schema)")
        group.post(use: createHandler)
    }
    
    private func createHandler(_ req: Request) async throws -> User.Public {
        
        let user = try req.content.decode(User.self)

        if (try  await User.query(on: req.db)
            .filter(\.$login == user.login)
            .first()) != nil {
            throw Abort(.conflict,reason: "Пользователь с таким логином уже зарегистрирован")
        }
        
        if (try await User.query(on: req.db)
            .filter(\.$email == user.email)
            .first()) != nil {
            throw Abort(.conflict, reason: "Email already used")
        }
            
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return user.convertToPublic()
    }
    
    
}
