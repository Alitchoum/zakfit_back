//
//  CreateFood.swift
//  zakfit_back
//
//  Created by alize suchon on 27/11/2025.
//

import Fluent

struct CreateFood: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Food.schema)
        
            .id()
            .field("name", .string, .required)
            .field("calorie_100g", .double, .required)
            .field("carbs_100g", .string, .required)
            .field("fats_100g", .double, .required)
            .field("proteins_100g", .double, .required)
            .field("is_auto", .bool, .sql(.default(false)))
            .field("total_fats", .double, .required)
            .field("user_id", .uuid, .references("users", "id"))
            .field("food_category_id", .uuid, .references("food_categories", "id"))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Food.schema).delete()
    }
}
