//
//  CreatePhysicalGoal.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//

import Fluent

struct CreatePhysicalGoal: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(PhysicalGoal.schema)
            .id()
            .field("duration", .int)
            .field("frequency", .int)
            .field("calories_burned", .double)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(PhysicalGoal.schema).delete()
    }
}
