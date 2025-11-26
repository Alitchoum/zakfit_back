//
//  FoodDTOS.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Fluent
import Vapor

struct FoodDTOS: Content {
    let name: String
    let calories100g: Double
    let carbs100g: Double
    let fats100g: Double
    let proteins100g: Double
    let isAuto: Bool
}

struct FoodResponse: Content {
    let id: UUID?
    let name: String
    let calories100g: Double
    let carbs100g: Double
    let fats100g: Double
    let proteins100g: Double
    let isAuto: Bool
}

struct FoodUpdate: Content {
    let name: String?
    let calories100g: Double?
    let carbs100g: Double?
    let fats100g: Double?
    let proteins100g: Double?
    let isAuto: Bool?
}

//Ajouter func toModel()
