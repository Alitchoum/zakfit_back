//
//  CreateFoodCategory.swift
//  zakfit_back
//
//  Created by alize suchon on 27/11/2025.
//

import Fluent

struct CreateFoodCategory: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(FoodCategory.schema)
        
            .id()
            .field("name", .string, .required)
            .field("picto", .string, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(FoodCategory.schema).delete()
    }
}
