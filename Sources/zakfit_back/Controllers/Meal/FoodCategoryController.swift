//
//  FoodCategoryController.swift
//  zakfit_back
//
//  Created by alize suchon on 27/11/2025.
//

import Vapor
import Fluent

struct FoodCategoryController: RouteCollection {
    func boot(routes: any RoutesBuilder){
        let foodCategories = routes.grouped("foodCategories")
        
        foodCategories.post(use: CreateFoodCategory)
        
    }
    
    //CREATE FOOD CATEGORY
    @Sendable
    func CreateFoodCategory(_ req: Request) async throws -> FoodCategoryResponseDTO {
        let dto = try req.content.decode(CreateFoodCategoryDTO.self)

        let foodCategory = FoodCategory(
            name: dto.name,
            picto: dto.picto,
        )
        
        try await foodCategory.save(on: req.db)
        return foodCategory.toResponse()
    }
    
    //AJOUTER AUTRES ROUTES PLUS TARD
}
