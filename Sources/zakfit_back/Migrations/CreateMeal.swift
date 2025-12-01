//
//  CreateMeal.swift
//  zakfit_back
//
//  Created by alize suchon on 27/11/2025.
//

import Fluent

struct CreateMeal: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Meal.schema)
        
            .id()
            .field("type", .string, .required)
            .field("image", .string)
            .field("total_calories", .double, .required)
            .field("total_proteins", .double, .required)
            .field("total_carbs", .double, .required)
            .field("total_fats", .double, .required)
            .field("date", .date, .required)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Meal.schema).delete()
    }
}
