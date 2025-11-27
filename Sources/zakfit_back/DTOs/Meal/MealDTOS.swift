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
    let contents: [MealContentDTO]
}

struct MealContentDTO: Content {
    let foodID: UUID
    let quantity: Double
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
    let totalCalories: Double?
    let totalProteins: Double?
    let totalCarbs: Double?
    let totalFats: Double?
    let date: Date?
}



//Pour calculer les totaux pour le repas, multiplier chaque nutriment par quantity / 100 :
//totalCalories=food.calories100g×(quantity/100)

//    static func validations(_ validations: inout Validations){
//        validations.add("totalCalories", as: Double.self, is: .range(0...))
//        validations.add("totalProteins", as: Double.self, is: .range(0...))
//        validations.add("totalCarbs", as: Double.self, is: .range(0...))
//        validations.add("totalFats", as: Double.self, is: .range(0...))
//    }
//        L'API effectue une vérification des données (par exemple, assure que les
//        valeurs nutritionnelles sont cohérentes avec les aliments enregistrés) avant
//        d'enregistrer le repas. A FAIRE !!!
