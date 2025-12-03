//
//  MealController.swift
//  zakfit_back
//
//  Created by alize suchon on 27/11/2025.
//

import Vapor
import Fluent

struct MealController: RouteCollection {
    func boot(routes: any RoutesBuilder) {
        let meals = routes.grouped("meals")
        let protected = meals.grouped(JWTMiddleware())
        
        protected.post("current", use: createMeal)
        protected.get("current", use: getUserMeals)
        protected.post(":mealID", "foods", use: addFoodToMeal)
        protected.get(":mealID", use: getMealDetails)
        protected.delete("current", ":id", use: deleteMeal)
    }
    
    // CREATE MEAL
    @Sendable
    func createMeal(req: Request) async throws -> MealWithFoodsResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        let dto = try req.content.decode(CreateMealDTO.self)
        
        let meal = Meal(
            type: dto.type,
            totalCalories: 0,
            totalProteins: 0,
            totalCarbs: 0,
            totalFats: 0,
            date: dto.date,
            userID: payload.id
        )
        try await meal.save(on: req.db)
        
        try await meal.$foodMeals.load(on: req.db)
        for fm in meal.foodMeals {
            try await fm.$food.load(on: req.db)
        }
        return meal.toMealWithFoodsResponse()
    }
    
    // ADD FOOD TO MEAL
    @Sendable
    func addFoodToMeal(req: Request) async throws -> MealWithFoodsResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        let mealID = try req.parameters.require("mealID", as: UUID.self)
        let dto = try req.content.decode(AddFoodToMealDTO.self)
        
        guard let meal = try await Meal.query(on: req.db)
            .filter(\.$id == mealID)
            .filter(\.$user.$id == payload.id)
            .first()
        else {
            throw Abort(.notFound, reason: "Meal not found")
        }
        
        guard let food = try await Food.find(dto.foodID, on: req.db) else {
            throw Abort(.notFound, reason: "Food not found")
        }
        
        let foodMeal = FoodMeal(
            quantity: dto.quantity,
            mealID: try meal.requireID(),
            foodID: try food.requireID()
        )
        try await foodMeal.save(on: req.db)
        
        // recalcul des totaux
        meal.totalCalories += food.calories100g * Double(dto.quantity) / 100
        meal.totalProteins += food.proteins100g * Double(dto.quantity) / 100
        meal.totalCarbs += food.carbs100g * Double(dto.quantity) / 100
        meal.totalFats += food.fats100g * Double(dto.quantity) / 100
        try await meal.update(on: req.db)
        
        // charger relations avant le retour
        try await meal.$foodMeals.load(on: req.db)
        for fm in meal.foodMeals {
            try await fm.$food.load(on: req.db)
        }
        
        return meal.toMealWithFoodsResponse()
    }
    
    // GET USER MEALS BY DAY
    @Sendable
    func getUserMeals(req: Request) async throws -> [MealWithFoodsResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)
        
        let today = Date()
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: today)
        let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)
        
        let meals = try await Meal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .filter(\.$date >= todayStart)
            .filter(\.$date < todayEnd!)
            .all()
        
        // charger relations pour chaque meal
        for meal in meals {
            try await meal.$foodMeals.load(on: req.db)
            for foodMeal in meal.foodMeals {
                try await foodMeal.$food.load(on: req.db)
            }
        }
        
        return meals.map { $0.toMealWithFoodsResponse() }
    }
    
    // GET MEAL DETAILS
    @Sendable
    func getMealDetails(req: Request) async throws -> MealWithFoodsResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        let mealID = try req.parameters.require("mealID", as: UUID.self)
        
        guard let meal = try await Meal.query(on: req.db)
            .filter(\.$id == mealID)
            .filter(\.$user.$id == payload.id)
            .first()
        else {
            throw Abort(.notFound, reason: "Meal not found")
        }
        
        try await meal.$foodMeals.load(on: req.db)
        for fm in meal.foodMeals {
            try await fm.$food.load(on: req.db)
        }
        
        return meal.toMealWithFoodsResponse()
    }
    
    // DELETE USER MEAL
    @Sendable
    func deleteMeal(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        let queryID = try req.parameters.require("id")
        
        guard let mealID = UUID(uuidString: queryID) else {
            throw Abort(.notFound, reason: "Invalid ID")
        }
        
        guard let meal = try await Meal.query(on: req.db)
            .filter(\.$id == mealID)
            .filter(\.$user.$id == payload.id)
            .first() else {
            throw Abort(.notFound, reason: "Meal not found")
        }
        
        let foodMeals = try await meal.$foodMeals.query(on: req.db).all()
        for fm in foodMeals {
            try await fm.delete(on: req.db)
        }
        
        try await meal.delete(on: req.db)
        return .noContent
    }
}
