//
//  UserMigration.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(User.schema)
        
            .id()
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("weight",.int)
            .field("size", .int)
            .field("objective", .string)
            .field("diet", .string)
            .field("gender", .string)
            .field("birthday", .date)
            .unique(on: "email")
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(User.schema).delete()
    }
}
