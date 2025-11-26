//
//  MealFoodDTOS.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Fluent
import Vapor

struct MealFoodDTOS: Content {
    let quantity: Int
    let mealID: UUID
    let foodID: UUID
}

struct MealFoodResponse: Content {
    let id: UUID?
    let quantity: Int
    let mealID: UUID
    let foodID: UUID
}

struct MealFoodUpdate: Content {
    let quantity: Int?
    let mealID: UUID?
    let foodID: UUID?
}

//Ajouter func toModel()
