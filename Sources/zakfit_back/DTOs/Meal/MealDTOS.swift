//
//  MealDTOS.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Fluent
import Vapor


struct CreateMealDTO: Content {
    let type: String
    let date: Date
}

struct MealResponseDTO: Content {
    let id: UUID?
    let type: String
    let totalCalories: Double
    let totalProteins: Double
    let totalCarbs: Double
    let totalFats: Double
    let date: Date
    let userId: UUID
}

struct FoodInMealResponseDTO: Content {
    let id: UUID
    let name: String
    let quantity: Int
    let calories: Double
    let carbs: Double
    let proteins: Double
    let fats: Double
}

struct MealWithFoodsResponseDTO: Content {
    let id: UUID?
    let type: String
    let totalCalories: Double
    let totalProteins: Double
    let totalCarbs: Double
    let totalFats: Double
    let date: Date
    let userId: UUID
    let foods: [FoodInMealResponseDTO]
}

struct AddFoodToMealDTO: Content {
    let foodID: UUID
    let quantity: Int
}
