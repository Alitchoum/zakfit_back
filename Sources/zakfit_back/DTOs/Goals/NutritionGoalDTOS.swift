//
//  NutritionGoalDTOS.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Fluent
import Vapor

struct NutritionGoalDTO: Content {
    let caloriesTarget: Double
    let proteinsTarget: Double?
    let carbsTarget: Double?
    let fatsTarget: Double?
    let isAuto: Bool
}

struct NutritionGoalResponseDTO: Content {
    let id: UUID?
    let caloriesTarget: Double
    let proteinsTarget: Double?
    let carbsTarget: Double?
    let fatsTarget: Double?
    let isAuto: Bool
    let userID: UUID
}

struct NutritionGoalUpdateDTO: Content {
    let caloriesTarget: Double?
    let proteinsTarget: Double?
    let carbsTarget: Double?
    let fatsTarget: Double?
    let isAuto: Bool?
}
