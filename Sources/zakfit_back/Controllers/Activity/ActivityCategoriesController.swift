//
//  ActivityCategories.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//

import Vapor
import Fluent

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
    
    //AJOUTER AUTRES ROUTES PLUS TARD (en dur)
}
