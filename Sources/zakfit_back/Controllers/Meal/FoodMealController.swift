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
        protected.patch("current", use: updateFoodMeal)
        protected.delete("current", use: deleteFoodMeal)
    }
    
    //CREATE FOOD MEAL BY USER
    @Sendable
    func createFoodMeal(req: Request) async throws -> FoodMealResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        
        try CreateFoodMealDTO.validate(content: req)
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
    
    //UPDATE BY USER
    @Sendable
    func updateFoodMeal(req: Request) async throws -> FoodMealResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        
        try FoodMealUpdateDTO.validate(content: req)
        let dto = try req.content.decode(FoodMealUpdateDTO.self)
        
        let queryID = try req.parameters.require("id")
        guard let foodMealID = UUID(uuidString: queryID) else {
            throw Abort(.badRequest, reason: "Invalid id")
        }
        
        // Charge avec relation (meal => pour recuperer user id)
        guard let foodMeal = try await FoodMeal.query(on: req.db)
            .filter(\.$id ==  foodMealID)
            .with(\.$meal)
            .first()
        
        else {
            throw Abort(.notFound, reason: "Food meal not found")
        }
        //verif foodMeal appartient bien à user
        guard foodMeal.meal.$user.id == payload.id else {
            throw Abort(.notFound, reason: "Cannot update this food meal")
        }
        
        if let quantity = dto.quantity { foodMeal.quantity = quantity }
        if let mealID = dto.mealID { foodMeal.$meal.id = mealID }
        if let foodID = dto.foodID { foodMeal.$food.id = foodID }
        
        try await foodMeal.update(on: req.db)
        return foodMeal.toResponse()
    }
    
    //DELETE BY USER
    @Sendable
    func deleteFoodMeal(req: Request) async throws -> HTTPStatus {
        
        let payload = try req.auth.require(UserPayload.self)
        
        let queryID = try req.parameters.require("id")
        guard let foodMealID = UUID(uuidString: queryID) else {
            throw Abort(.badRequest, reason: "Invalid id")
        }
        
        guard let foodMeal = try await FoodMeal.query(on : req.db)
            .filter(\.$id == foodMealID)
            .with(\.$meal)
            .first() else {
            throw Abort(.notFound, reason: "Food meal not found")
        }
        
        guard foodMeal.meal.$user.id == payload.id else {
            throw Abort(.forbidden, reason: "Not your food meal")
        }
        try await foodMeal.delete(on: req.db)
        return .noContent
    }
}
