//
//  CreateFoodMeal.swift
//  zakfit_back
//
//  Created by alize suchon on 27/11/2025.
//

import Fluent

struct CreateFoodMeal: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(FoodMeal.schema)
        
            .id()
            .field("quantity", .int, .required)
            .field("meal_id", .uuid, .required, .references("meals", "id"))
            .field("food_id", .uuid, .required, .references("foods", "id"))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(FoodMeal.schema).delete()
    }
}
