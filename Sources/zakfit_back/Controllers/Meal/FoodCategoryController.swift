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
        foodCategories.get(use: getAll)
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
    
    //GET ALL
    @Sendable
    func getAll (req: Request) async throws -> [FoodCategoryResponseDTO] {
        let foodCategories = try await FoodCategory.query(on: req.db).all()
        return foodCategories.map{$0.toResponse()}
    }
    
    //AJOUTER AUTRES ROUTES PLUS TARD
}
