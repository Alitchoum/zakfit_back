//
//  Profil.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Vapor
import Fluent

final class User : Model, @unchecked Sendable, Authenticatable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "last_name")
    var lastName: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "weight")
    var weight: Int?
    
    @Field(key: "size")
    var size: Int?
    
    @Field(key: "objective")
    var objective: String?
    
    @Field(key: "diet")
    var diet: String?
    
    @Field(key: "gender")
    var gender: String?
    
    @Field(key: "birthday")
    var birthday: Date?
    
    // MARK: - Relations
    
    @Children(for: \.$user)
    var activities: [Activity]
    
    @Children(for: \.$user)
    var meals: [Meal]
    
    @Children(for: \.$user)
    var physicalGoals: [PhysicalGoal]
    
    @Children(for: \.$user)
    var nutritionGoals: [NutritionGoal]
    
    @Children(for: \.$user)
    var foods: [Food]
    
    init() {}
    
    init(id: UUID? = nil, firstName: String, lastName: String, email: String, password: String, weight: Int? = nil, size: Int? = nil , objective: String? = nil, diet: String? = nil, gender: String? = nil , birthday: Date? = nil) {
        self.id = id ?? UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email.description
        self.password = password
        self.weight = weight
        self.size = size
        self.objective = objective
        self.diet = diet
        self.gender = gender
        self.birthday = birthday
    }
    
    func toResponse() -> UserResponseDTO {
        UserResponseDTO (
            id: self.id,
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email,
            weight: self.weight,
            size: self.size,
            objective: self.objective,
            diet: self.diet,
            gender: self.gender,
            birthday: self.birthday
        )
    }
}
