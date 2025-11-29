//
//  MealController.swift
//  zakfit_back
//
//  Created by alize suchon on 27/11/2025.
//

import Vapor
import Fluent

struct MealController: RouteCollection {
    func boot(routes: any RoutesBuilder){
        let meals = routes.grouped("meals")
        let protected = meals.grouped(JWTMiddleware())
        
        protected.post("current", use: createMeal)
        protected.get("current", use: getUserMeals)
        protected.delete("current", ":id", use: deleteMeal)
    }
    
    // CREATE USER MEAL
    @Sendable
    func createMeal(req: Request) async throws -> MealResponseDTO {

        let payload = try req.auth.require(UserPayload.self)
        
        //try CreateMealDTO.validate(content: req)
        let dto = try req.content.decode(CreateMealDTO.self)
        
        let meal = Meal(
            type: dto.type,
            picto: dto.picto,
            totalCalories: 0,
            totalProteins: 0,
            totalCarbs: 0,
            totalFats: 0,
            date: dto.date,
            userID: payload.id
        )
        try await meal.save(on: req.db)
        
        var totalCalories: Double = 0
        var totalProteins: Double = 0
        var totalCarbs: Double = 0
        var totalFats: Double = 0
        
        // Parcours  aliments pour créer les FoodMeals
        for foodDTO in dto.foods {
            guard let food = try await Food.find(foodDTO.id, on: req.db) else {
                throw Abort(.notFound, reason: "Food not found")
            }
            
            let foodMeal = FoodMeal(
                quantity: foodDTO.quantity,
                mealID: try meal.requireID(),
                foodID: try food.requireID()
            )
            try await foodMeal.save(on: req.db)
            
            // Calcul des totaux en fonction de la quantité
            totalCalories += food.calories100g *  Double(foodDTO.quantity / 100)
            totalProteins += food.proteins100g * Double(foodDTO.quantity / 100)
            totalCarbs += food.carbs100g * Double(foodDTO.quantity / 100)
            totalFats += food.fats100g * Double(foodDTO.quantity / 100)
        }
        
        // Mise à jour des totaux dans le meal
        meal.totalCalories = totalCalories
        meal.totalProteins = totalProteins
        meal.totalCarbs = totalCarbs
        meal.totalFats = totalFats
        try await meal.update(on: req.db)
        
        // Charger les aliments associés pour renvoyer la réponse complète
        try await meal.$foodMeals.load(on: req.db)
        for foodMeal in meal.foodMeals {
            try await foodMeal.$food.load(on: req.db)
        }
        return meal.toResponse()
    }

    //GET USER MEALS
    @Sendable
    func getUserMeals(req: Request) async throws -> [MealResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)
        
        let meals = try await Meal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .all()
        
        return meals.map{$0.toResponse()}
    }
    
    //DELETE USER MEAL
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
            .first()
        else {
            throw Abort(.notFound, reason: "Meal not found")
        }
        //SUPPRIME FOODMEALS LIÉs
       let foodMeal = try await meal.$foodMeals.query(on: req.db).all()
            for foodMeal in foodMeal {
            try await foodMeal.delete(on: req.db)
        }
        try await meal.delete(on: req.db)
        return .noContent
    }
    
    //UPDATE USER MEAL 
}
