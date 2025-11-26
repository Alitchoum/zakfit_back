//
//  NutritionGoalDTOS.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Fluent
import Vapor

struct PhysicalGoalDTO: Content {
    let duration: Int?
    let frequency: Int?
    let caloriesBurned: Double?
}

struct PhysicalGoalResponse: Content {
    let id: UUID?
    let duration: Int?
    let frequency: Int?
    let caloriesBurned: Double?
    let userID: UUID
}

struct PhysicalGoalUpdate: Content {
    let duration: Int?
    let frequency: Int?
    let caloriesBurned: Double?
}

//Ajouter func toModel()
