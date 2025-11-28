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
        protected.post("current", use: createNutritionGoal)
        protected.patch("current", use: updateNutritionGoal)
        protected.delete("current", use: deleteNutritionGoal)
        protected.get("current", use: getUserGoal)
    }
    
    //CREATE USER GOAL
    @Sendable
    func createNutritionGoal(req: Request) async throws -> NutritionGoalResponseDTO {
        let dto = try req.content.decode(NutritionGoalDTO.self)
        
        let payload = try req.auth.require(UserPayload.self)
        
        //VERIF SI DÉJÀ UN OBJECTIF
        let goalExist = try await NutritionGoal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first()
        
        if goalExist != nil  {
            throw Abort(.badRequest, reason: "You already have a nutrition goal")
        }
        
        let nutritionGoal = NutritionGoal(
            caloriesTarget: dto.caloriesTarget,
            proteinsTarget: dto.proteinsTarget,
            carbsTarget: dto.carbsTarget,
            fatsTarget: dto.fatsTarget,
            isAuto: dto.isAuto,
            userID: payload.id
        )
        
        //AJOUTER PLUS TARD VERSION AUTOMATIQUE ICI "CALCUL AUTO"
        
        try await nutritionGoal.save(on: req.db)
        return nutritionGoal.toResponse()
    }
    
    //GET USER GOAL
    @Sendable
    func getUserGoal(req: Request) async throws -> NutritionGoalResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let nutritionGoal = try await NutritionGoal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first() else {
            throw Abort(.notFound, reason: "Nutrition Goal not found")
        }
        return nutritionGoal.toResponse()
    }
    
    //UPDATE USER GOAL
    @Sendable
    func updateNutritionGoal(req: Request) async throws -> NutritionGoalResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let nutriGoal = try await NutritionGoal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first() else {
            throw Abort(.notFound, reason: "Nutrition Goal not found")
        }
        
        let updatedData = try req.content.decode(NutritionGoalUpdateDTO.self)
        
        if let caloriesTarget = updatedData.caloriesTarget { nutriGoal.caloriesTarget = caloriesTarget }
        if let proteinsTarget = updatedData.proteinsTarget { nutriGoal.proteinsTarget = proteinsTarget }
        if let carbsTarget = updatedData.carbsTarget { nutriGoal.carbsTarget = carbsTarget }
        if let fatsTarget = updatedData.fatsTarget { nutriGoal.fatsTarget = fatsTarget }
        if let isAuto = updatedData.isAuto { nutriGoal.isAuto = isAuto }
        
        try await nutriGoal.update(on: req.db)
        return nutriGoal.toResponse()
    }
    
    //DELETE USER GOAL
    @Sendable
    func deleteNutritionGoal(req: Request) async throws -> HTTPStatus {
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let nutriGoal = try await NutritionGoal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first() else {
            throw Abort(.notFound, reason: "Nutrition Goal not found")
        }
        
        try await nutriGoal.delete(on: req.db)
        return .noContent
    }
}

