//
//  PhysicalGoalController.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//

import Vapor
import Fluent

struct PhysicalGoalController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        
        let physicalGoal = routes.grouped("physicalGoal")
        let protected = physicalGoal.grouped(JWTMiddleware())
        
        protected.post("current", use: createPhysicalGoal)
        protected.get("current", use: getUserGoal)
        protected.patch("current", use: updatePhysicalGoal)
        protected.delete("current", use: deletePhysicalGoal)
    }
    
    //CREATE
    @Sendable
    func createPhysicalGoal(req: Request) async throws -> PhysicalGoalResponseDTO {
        let dto = try req.content.decode(PhysicalGoalDTO.self)
        
        let payload = try req.auth.require(UserPayload.self)
        
        //VERIF SI OBJECTIF EXIST DÉJÀ
        let goalExist = try await PhysicalGoal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first()
        
        if goalExist != nil {
            throw Abort(.badRequest, reason: "You already have a physical goal")
        }
        
        let physicalGoal = PhysicalGoal(
            duration: dto.duration,
            frequency: dto.frequency,
            calorieBurned: dto.caloriesBurned,
            userID: payload.id
        )
        try await physicalGoal.save(on: req.db)
        return physicalGoal.toResponse()
    }
    
    //GET USER PHYSICAL GOAL
    @Sendable
    func getUserGoal(req: Request) async throws -> PhysicalGoalResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let physicalGoal = try await PhysicalGoal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first() else {
            throw Abort(.notFound, reason: "Nutrition Goal not found")
        }
        return physicalGoal.toResponse()
    }
    
    //UPDATE GOAL
    @Sendable
    func updatePhysicalGoal(req: Request) async throws -> PhysicalGoalResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let updateData = try req.content.decode(PhysicalGoalUpdateDTO.self)
        
        guard let physicalGoal = try await PhysicalGoal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first() else {
            throw Abort(.notFound, reason: "Nutrition Goal not found")
        }
        
        if let duration = updateData.duration { physicalGoal.duration = duration}
        if let frequency = updateData.frequency { physicalGoal.frequency = frequency}
        if let caloriesBurned = updateData.caloriesBurned { physicalGoal.caloriesBurned = caloriesBurned}
        
        try await physicalGoal.update(on: req.db)
        return physicalGoal.toResponse()
    }
    
    //DELETE
    @Sendable
    func deletePhysicalGoal(req: Request) async throws -> HTTPStatus {
        
        let payload = try req.auth.require(UserPayload.self)

        guard let physicalGoal = try await PhysicalGoal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first() else {
            throw Abort(.notFound, reason: "Nutrition Goal not found")
        }
        try await physicalGoal.delete(on: req.db)
        return .noContent
    }
}
