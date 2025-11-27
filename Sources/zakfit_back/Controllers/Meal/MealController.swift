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
        
//        protected.post(use: createMeal)
    }
    
    //CREATE USER MEAL
//    @Sendable
//    func createMeal(req: Request) async throws -> MealResponseDTO {
//        
//        let payload = try req.auth.require(UserPayload.self)
//        
//        try CreateMealDTO.validate(content: req)
//        let dto = try req.content.decode(CreateMealDTO.self)
//        
//        let meal = Meal(
//            type: dto.type,
//            picto: dto.picto,
//            totalCalories: dto.totalCalories,
//            totalProteins: dto.totalProteins,
//            totalCarbs: dto.totalCarbs,
//            totalFats: dto.totalFats,
//            date: dto.date,
//            userID: payload.id
//        )
//        try await meal.save(on: req.db)
//        return meal.toResponse()
//    }
    
    //GET USER MEALS
    @Sendable
    func getUserMeals(req: Request) async throws -> [MealResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)
        
        let meals = try await Meal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .all()
           
        return meals.map{$0.toResponse()}
    }
    
    //AJOUTER AUTRES ROUTES PLUS TARD
}
