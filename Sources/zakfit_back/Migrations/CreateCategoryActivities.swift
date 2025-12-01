//
//  CreateCategoryActivities.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//


import Fluent

struct CreateCategoryActivities: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(CategoryActivity.schema)
        
            .id()
            .field("name", .string, .required)
            .field("picto", .string, .required)
            .field("color", .string, .required)
            .field("index_order", .int, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(CategoryActivity.schema).delete()
    }
}
