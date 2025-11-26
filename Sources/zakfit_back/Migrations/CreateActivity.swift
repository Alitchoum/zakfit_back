//
//  CreateActivity.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//

import Fluent

struct CreateActivity: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Activity.schema)
        
            .id()
            .field("duration", .int, .required)
            .field("calories_burned", .int)
            .field("date", .date, .required)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("activity_category_id", .uuid, .required, .references("activity_categories", "id"))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Activity.schema).delete()
    }
}
