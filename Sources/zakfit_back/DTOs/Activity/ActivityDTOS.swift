//
//  ActivityDTO.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Fluent
import Vapor

struct ActivityDTO: Content, Validatable {
    let duration: Int
    let caloriesBurned: Int
    let date: Date
    let categoryId: UUID
    
    static func validations(_ validations: inout Validations) {
        validations.add("duration", as: Int.self, is : .range(1...360)) //6H max
        validations.add("caloriesBurned", as: Int.self, is : .range(0...2000))
    }
}

struct ActivityResponseDTO: Content {
    let id: UUID?
    let duration: Int
    let caloriesBurned: Int
    let date: Date
    let categoryId: UUID
}

struct ActivityUpdateDTO: Content {
    let duration: Int?
    let caloriesBurned: Int?
    let categoryId: UUID?
    let date: Date?
}

extension ActivityDTO {
    func toModel(userID: UUID) -> Activity {
        return Activity(
            duration: duration,
            caloriesBurned: caloriesBurned,
            date: date,
            userID: userID,
            activityCategoryID: categoryId
        )
    }
}
