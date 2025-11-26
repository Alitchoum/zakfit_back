//
//  CreateNutriGoal.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//

import Fluent

struct CreateNutritionGoal: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(NutritionGoal.schema)
            .id()
            .field("calories_target", .double, .required)
            .field("proteins_target", .double)
            .field("carbs_target", .double)
            .field("fats_target", .double)
            .field("is_auto", .bool, .required, .sql(.default(false)))
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(NutritionGoal.schema).delete()
    }
}


