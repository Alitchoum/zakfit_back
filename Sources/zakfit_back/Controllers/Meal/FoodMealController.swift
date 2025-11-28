//
//  FoodMealController.swift
//  zakfit_back
//
//  Created by alize suchon on 27/11/2025.
//

import Vapor
import Fluent

struct FoodMealController: RouteCollection {
    func boot(routes: any RoutesBuilder){
        let foodMeals = routes.grouped("foodMeals")
        
        let protected = foodMeals.grouped(JWTMiddleware())
        protected.post("current", use: createFoodMeal)
        
    }
    
    //CREATE FOOD MEAL
    @Sendable
    func createFoodMeal(req: Request) async throws -> FoodMealResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        
        let dto = try req.content.decode(CreateFoodMealDTO.self)
        
        // Vérifie que le meal appartient à l'user
        guard let meal = try await Meal.find(dto.mealID, on: req.db),
              meal.$user.id == payload.id else {
            throw Abort(.forbidden, reason: "You cannot add foods to this meal")
        }
        
        let foodMeal = FoodMeal(
            quantity: dto.quantity,
            mealID: dto.mealID,
            foodID: dto.foodID
        )
        
        try await foodMeal.save(on: req.db)
        return foodMeal.toResponse()
    }
    
    //AJOUTER AUTRES ROUTES PLUS TARD
}
