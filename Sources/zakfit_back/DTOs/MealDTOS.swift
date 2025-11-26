//
//  MealDTOS.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Fluent
import Vapor

struct MealDTOS: Content {
    
    let type: String
    let image: String?
    let picto: String
    let totalCalories: Double
    let totalProteins: Double
    let totalCarbs: Double
    let totalFats: Double
    let date: Date
}

struct MealResponse: Content {
    
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

struct MealUpdate: Content {
    
    let type: String?
    let image: String?
    let picto: String?
    let totalCalories: Double?
    let totalProteins: Double?
    let totalCarbs: Double?
    let totalFats: Double?
    let date: Date?
}

//A ajouter plus tard si besoin

//struct MealWithFoodsResponse: Content {
//    let id: UUID?
//    let type: String
//    let image: String?
//    let picto: String
//    let totalCalories: Double
//    let totalProteins: Double
//    let totalCarbs: Double
//    let totalFats: Double
//    let date: Date
//    let userId: UUID
//    let foods: [MealFoodResponse]
//}



//Pour calculer les totaux pour le repas, multiplier chaque nutriment par quantity / 100 :
//totalCalories=food.calories100g×(quantity/100)
