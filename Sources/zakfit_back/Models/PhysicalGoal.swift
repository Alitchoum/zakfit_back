//
//  NutritionGoal.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Vapor
import Fluent

final class PhysicalGoal: Model, Content, @unchecked Sendable {
    static let schema = "physical_goals"
    
    @ID(key: .id)
    var id : UUID?
    
    @OptionalField(key: "duration")
    var duration: Int?
    
    @OptionalField(key: "frequency")
    var frequency: Int?
    
    @OptionalField(key: "calories_burned")
    var caloriesBurned: Double?
    
    // MARK: - Relation
    
    @Parent(key: "user_id")
    var user: User
    
    init(){}
    
    init(duration: Int? = nil, frequency: Int? = nil, calorieBurned: Double? = nil, userID: UUID){
        self.duration = duration
        self.frequency = frequency
        self.caloriesBurned = calorieBurned
        self.$user.id = userID
    }
    
    func toResponse() -> PhysicalGoalResponseDTO {
        PhysicalGoalResponseDTO(
            id: self.id,
            duration: self.duration,
            frequency: self.frequency,
            caloriesBurned: self.caloriesBurned,
            userID: self.$user.id
        )
    }
}
