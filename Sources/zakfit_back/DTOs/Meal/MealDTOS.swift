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
    let image: String?
    let picto: String
    let date: Date
    let foods: [FoodsDTO]
}

struct FoodsDTO: Content {
    let id: UUID
    let quantity: Int
}

struct MealResponseDTO: Content {
    
    let id: UUID?
    let type: String
    let image: String?
    let picto: String
    let totalCalories: Double
    let totalProteins: Double
    let totalCarbs: Double
    let totalFats: Double
    let date: Date
    let userId: UUID
}

struct MealUpdateDTO: Content {
    
    let type: String?
    let image: String?
    let picto: String?
    let date: Date?
    let foods: [FoodsDTO]?
}
