//
//  PhysicalGoal.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Vapor
import Fluent


final class NutritionGoal: Model, Content, @unchecked Sendable {
    static let schema = "nutrition_goals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "calories_target")
    var caloriesTarget: Double
    
    @OptionalField(key: "proteins_target")
    var proteinsTarget: Double?
    
    @OptionalField(key: "carbs_target")
    var carbsTarget: Double?
    
    @OptionalField(key: "fats_target")
    var fatsTarget: Double?
    
    @Field(key: "is_auto")
    var isAuto: Bool
    
    // MARK: - Relation
    @Parent(key: "user_id")
    var user: User
    
    init() {}
    
    init(
        id: UUID? = nil,
        caloriesTarget: Double,
        proteinsTarget: Double? = nil,
        carbsTarget: Double? = nil,
        fatsTarget: Double? = nil,
        isAuto: Bool = false,
        userID: UUID
    ) {
        self.id = id
        self.caloriesTarget = caloriesTarget
        self.proteinsTarget = proteinsTarget
        self.carbsTarget = carbsTarget
        self.fatsTarget = fatsTarget
        self.isAuto = isAuto
        self.$user.id = userID 
    }
    
    func toResponse() -> NutritionGoalResponseDTO {
        NutritionGoalResponseDTO(
            id: self.id,
            caloriesTarget: self.caloriesTarget,
            proteinsTarget: self.proteinsTarget,
            carbsTarget: self.carbsTarget,
            fatsTarget: self.fatsTarget,
            isAuto: self.isAuto,
            userID: self.$user.id
        )
    }
}
