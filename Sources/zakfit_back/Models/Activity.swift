//
//  Activity.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Vapor
import Fluent

final class Activity: Model, Content, @unchecked Sendable {
    static let schema = "activities"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "duration")
    var duration: Int
    
    @Field(key: "calories_burned")
    var caloriesBurned: Int
    
    @Field(key: "date")
    var date : Date
    
    // MARK: - Relations
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "activity_category_id")
    var category: CategoryActivity
    
    init() {}
    
    init(duration: Int, caloriesBurned: Int, date: Date, userID: UUID, activityCategoryID: UUID) {
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.date = date
        self.$user.id = userID
        self.$category.id = activityCategoryID
    }
    
    func toResponse() -> ActivityResponseDTO {
        ActivityResponseDTO(
            id: self.id,
            duration: self.duration,
            caloriesBurned: self.caloriesBurned,
            date: self.date,
            categoryId: self.$category.id,
            categoryName: self.category.name,
            categoryPicto: self.category.picto,
            categoryColor: self.category.color
        )
    }
}
