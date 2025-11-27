//
//  FoodDTOS.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Fluent
import Vapor

struct CreateFoodDTO: Content {
    let name: String
    let calories100g: Double
    let carbs100g: Double
    let fats100g: Double
    let proteins100g: Double
    let isAuto: Bool
    let userID: UUID?
    let foodCategoryID: UUID
}

struct FoodResponseDTO: Content {
    let id: UUID?
    let name: String
    let calories100g: Double
    let carbs100g: Double
    let fats100g: Double
    let proteins100g: Double
    let isAuto: Bool
    let userID: UUID?
    let foodCategoryID: UUID
}

struct FoodUpdateDTO: Content {
    let name: String?
    let calories100g: Double?
    let carbs100g: Double?
    let fats100g: Double?
    let proteins100g: Double?
    let isAuto: Bool?
    let foodCategoryID: UUID?
}

//Ajouter func toModel()
