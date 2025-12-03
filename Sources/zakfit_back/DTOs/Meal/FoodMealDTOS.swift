//
//  MealFoodDTOS.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Fluent
import Vapor

struct CreateFoodMealDTO: Content, Validatable {
    let quantity: Int
    let mealID: UUID
    let foodID: UUID
    
    static func validations(_ validations: inout Validations) {
        validations.add("quantity", as: Int.self, is : .range(0...))
        validations.add("mealID", as: UUID.self)
        validations.add("foodID", as: UUID.self)
    }
}

struct FoodMealResponseDTO: Content {
    let id: UUID?
    let quantity: Int
    let mealID: UUID
    let foodID: UUID
}

struct FoodMealUpdateDTO: Content, Validatable {
    let quantity: Int?
    let mealID: UUID?
    let foodID: UUID?
    
    static func validations(_ validations: inout Validations) {
        validations.add("quantity", as: Int.self, is : .range(0...))
        validations.add("mealID", as: UUID.self)
        validations.add("foodID", as: UUID.self)
    }
}
