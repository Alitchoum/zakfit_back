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
        let physicalGoals = routes.grouped("PysicalGoals")
        let protected = physicalGoals.grouped(JWTMiddleware())
        
    }
    //CREATE
    //GET USER PHYSICAL GOAL
    //UPDATE GOAL
    //DELETE
}
