//
//  FoodController.swift
//  zakfit_back
//
//  Created by alize suchon on 27/11/2025.
//

import Vapor
import Fluent

struct FoodController: RouteCollection {
    func boot(routes: any RoutesBuilder){
        let foods = routes.grouped("foods")
        
        foods.post(use: createFood)
        foods.get(use: getAll)
        
        foods.patch(":foodID", use: updateFood)
        
        let protected = foods.grouped(JWTMiddleware())
        protected.post("current", use: createUserFood)
        protected.patch("current", ":foodID", use: updateUserFood)
    }
    
    //CREATE GLOBAL (admin)
    @Sendable
    func createFood(req: Request) async throws -> FoodResponseDTO {
        let dto = try req.content.decode(CreateFoodDTO.self)
        
        let food = Food(
            name: dto.name,
            calories100g: dto.calories100g,
            carbs100g: dto.carbs100g,
            fats100g: dto.fats100g,
            proteins100g: dto.proteins100g,
            isAuto: dto.isAuto,
            userID: dto.userID,
            foodCategoryID: dto.foodCategoryID
        )
        try await food.save(on: req.db)
        return food.toResponse()
    }
    
    //CREATE BY USER
    @Sendable
    func createUserFood(req: Request) async throws -> FoodResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        
        let dto = try req.content.decode(CreateFoodDTO.self)
        
        let food = Food(
            name: dto.name,
            calories100g: dto.calories100g,
            carbs100g: dto.carbs100g,
            fats100g: dto.fats100g,
            proteins100g: dto.proteins100g,
            isAuto: dto.isAuto,
            userID: payload.id,
            foodCategoryID: dto.foodCategoryID
        )
        try await food.save(on: req.db)
        return food.toResponse()
    }
    
    //GET ALL
    @Sendable
    func getAll (req: Request) async throws -> [FoodResponseDTO] {
        let foods = try await Food.query(on: req.db).all()
        return foods.map {$0.toResponse()}
    }
    
    //UPDATE BY USER
    @Sendable
    func updateUserFood(req: Request) async throws -> FoodResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        let foodID = try req.parameters.require("foodID", as: UUID.self)

        guard let food = try await Food.query(on: req.db)
            .filter(\.$id == foodID)
            .filter(\.$user.$id == payload.id)
            .first() else {
            throw Abort(.notFound, reason: "Food not found")
        }
        
        let updateData = try req.content.decode(FoodUpdateDTO.self)
        if let name = updateData.name {food.name = name }
        if let calories100g = updateData.calories100g {food.calories100g = calories100g }
        if let carbs100g = updateData.carbs100g {food.carbs100g = carbs100g }
        if let fats100g = updateData.fats100g {food.fats100g = fats100g}
        if let isAuto = updateData.isAuto {food.isAuto = isAuto }
        if let foodCategoryID = updateData.foodCategoryID {food.$foodCategory.id = foodCategoryID}
        
        try await food.update(on: req.db)
        return food.toResponse()
        }
    
    //UPDATE GLOBAL
    @Sendable
    func updateFood(req: Request) async throws -> FoodResponseDTO {
        
        let foodID = try req.parameters.require("foodID", as: UUID.self)

        guard let food = try await Food.query(on: req.db)
            .filter(\.$id == foodID)
            .filter(\.$user.$id == nil)
            .first() else {
            throw Abort(.notFound, reason: "Food not found")
        }
        
        let updateData = try req.content.decode(FoodUpdateDTO.self)
        if let name = updateData.name {food.name = name }
        if let calories100g = updateData.calories100g {food.calories100g = calories100g }
        if let carbs100g = updateData.carbs100g {food.carbs100g = carbs100g }
        if let fats100g = updateData.fats100g {food.fats100g = fats100g}
        if let isAuto = updateData.isAuto {food.isAuto = isAuto }
        if let foodCategoryID = updateData.foodCategoryID {food.$foodCategory.id = foodCategoryID}
        
        try await food.update(on: req.db)
        return food.toResponse()
    }
    
    //DELETE GLOBAL
    //DELETE USER FOOD
}
