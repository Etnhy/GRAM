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
        group.get("all", use: getAllusers)
        group.post("auth", use: authHandler)
    }
    
    private func createHandler(_ req: Request) async throws -> User.Public {
        let user = try req.content.decode(User.self)
        if (try  await User.query(on: req.db)
            .filter(\.$login == user.login)
            .first()) != nil {
            throw Abort(.conflict,reason: "A user with this login is already registered")
        }
        
        if (try await User.query(on: req.db)
            .filter(\.$email == user.email)
            .first()) != nil {
            throw Abort(.conflict, reason: "A user with this email is already registered")
        }
            
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return user.convertToPublic()
    }
    
    private func getAllusers(_ req: Request) async throws -> [User.Public] {
        let users = try await User.query(on: req.db).all()
        return users.map {$0.convertToPublic()}
    }
    
    
    func authHandler(_ req: Request) async throws -> User.Public {
        let userDTO = try req.content.decode(AuthUserDTO.self)
        guard let user = try await User.query(on: req.db).filter("login",.equal,userDTO.login).first() else {
            throw Abort(.notFound)
        }
        let isPassEqual = try Bcrypt.verify(userDTO.password, created: user.password)
        guard isPassEqual else { throw Abort(.unauthorized)}
        return user.convertToPublic()
    }
    
}
