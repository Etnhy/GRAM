//
//  CreateUser.swift
//
//
//  Created by evhn on 20.02.2024.
//

import Fluent
import Vapor


struct CreateUser: AsyncMigration {

    func prepare(on database: FluentKit.Database) async throws {
        let scheme = database.schema(User.schema)
            .id()
            .field("login", .string, .required)
            .field("email",.string,.required)
            .field("password", .string, .required)
            .field("name", .string, .required)
            .field("age", .int)
            .field("hobby", .string)
        try await scheme.create()

    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema(User.schema).delete()
    }
    
}
