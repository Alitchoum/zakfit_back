//
//  NutrutionGoalController.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//

import Vapor
import Fluent

struct NutritionGoalController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let nutritionGoal = routes.grouped("nutritionGoal")
        
        let protected = nutritionGoal.grouped(JWTMiddleware())
        protected.post(use: createNutritionGoal)
    }
    
    //CREATE
    @Sendable
    func createNutritionGoal(req: Request) async throws -> NutritionGoalResponseDTO {
        let dto = try req.content.decode(NutritionGoalDTO.self)
        
        let nutritionGoal = NutritionGoal(
            
        )
        try await nutritionGoal.save(on: req.db)
        return nutritionGoal.toResponse()
    }
    //GET ALL
    //GET BY ID
    //UPDATE
    //DELETE
   
    
}

