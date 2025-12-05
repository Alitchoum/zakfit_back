//
//  ActivityCategories.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//

import Vapor
import Fluent
import SQLKit
import FluentMySQLDriver

struct CategoryActivitiesController: RouteCollection {
    func boot (routes: any RoutesBuilder) throws {
        let categoryactivities = routes.grouped("categoryactivities")
        
        categoryactivities.post(use: createCategory)
        categoryactivities.get(use: getAll)
    }
    
    //CREATE
    @Sendable
    func createCategory(_ req: Request) async throws -> CategoryActivityResponseDTO {
        let dto = try req.content.decode(CategoryActivityDTO.self)
        
        let category = CategoryActivity(
            name: dto.name,
            picto: dto.picto,
            color: dto.color,
            indexOrder: dto.indexOrder
        )
        try await category.save(on: req.db)
        return category.toResponse()
    }
  
    //GET ALL
    @Sendable
    func getAll(req: Request) async throws -> [CategoryActivityResponseDTO] {
        
        let categories: [CategoryActivity] = try await CategoryActivity.query(on: req.db)
            .sort(\.$indexOrder, .ascending)
            .all()
        
        return categories.map{$0.toResponse()}
    }
}


// GET ALL CAT(SQL brut)
//    @Sendable
//    func getAll(req: Request) async throws -> [CategoryActivityResponseDTO] {
//            // Cast vers SQLDatabase pour accéder au SQL brut
//            guard let sqlDB = req.db as? SQLDatabase else {
//                throw Abort(.internalServerError, reason: "Database does not support raw SQL")
//            }
//
//            let rows = try await sqlDB.raw("""
//                SELECT id, name, picto, color, index_order
//                FROM category_activities
//                ORDER BY index_order ASC
//            """).all()
//
//            return try rows.map { row in
//                guard
//                    let id = try? row.decode(column: "id", as: UUID.self),
//                    let name = try? row.decode(column: "name", as: String.self),
//                    let picto = try? row.decode(column: "picto", as: String.self),
//                    let color = try? row.decode(column: "color", as: String.self),
//                    let indexOrder = try? row.decode(column: "index_order", as: Int.self)
//                else {
//                    throw Abort(.internalServerError, reason: "Invalid row data")
//                }
//                return CategoryActivityResponseDTO(
//                    id: id,
//                    name: name,
//                    picto: picto,
//                    color: color,
//                    indexOrder: indexOrder
//                )
//            }
//        }
//    }
