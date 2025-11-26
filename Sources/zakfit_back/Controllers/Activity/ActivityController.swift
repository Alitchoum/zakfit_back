//
//  ActivityController.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//

import Vapor
import Fluent

struct ActivityController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let activities = routes.grouped("activities")
        // activies.get(use: getAllActivities) public ou privée ??
        
        let protected = activities.grouped(JWTMiddleware())
        protected.post(use: createActivity)
        protected.get(use: getAllActivities)
    }
    
    //CREATE
    @Sendable
    func createActivity(req: Request) async throws -> ActivityResponseDTO {
        
        try ActivityDTO.validate(content: req)
        let dto = try req.content.decode(ActivityDTO.self)
        
        let payload = try req.auth.require(UserPayload.self) // Charge user connecté
        let activity = dto.toModel(userID: payload.id)
        
        //verif si categorie existe
        guard let _ = try await CategoryActivity.find(dto.categoryId, on: req.db) else {
            throw Abort(.badRequest, reason: "Category not found")
        }
        
        try await activity.save(on: req.db)
        return activity.toResponse()
    }
    
    //GET ALL
    @Sendable
    func getAllActivities(req: Request) async throws -> [ActivityResponseDTO] {
        let activities = try await Activity.query(on: req.db)
            .all()
        return activities.map{$0.toResponse()}
    }
}
