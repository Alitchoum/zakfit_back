//
//  Food.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Vapor
import Fluent

final class Food: Model, Content, @unchecked Sendable {
    static let schema = "foods"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "calories_100g")
    var calories100g: Double
    
    @Field(key: "carbs_100g")
    var carbs100g: Double
    
    @Field(key: "fats_100g")
    var fats100g: Double
    
    @Field(key: "proteins_100g")
    var proteins100g: Double
    
    @Field(key: "is_auto")
    var isAuto: Bool
    
    // MARK: - Relations
    
    @OptionalParent(key: "user_id")
    var user: User?

    @Parent(key: "food_category_id")
    var foodCategory: FoodCategory
    
    @Children(for: \.$food)
    var foodMeals: [FoodMeal]
    
    //créer lien  table meal  vers table food via table food_meal - lien des repas contenant cet aliment
    @Siblings(through: FoodMeal.self, from: \.$food , to: \.$meal)
    var meals: [Meal]
    
    init() {}
    
    init(name: String, calories100g: Double, carbs100g: Double, fats100g: Double, proteins100g: Double, isAuto: Bool, userID: UUID? = nil , foodCategoryID: UUID)
    {
        self.name = name
        self.calories100g = calories100g
        self.carbs100g = carbs100g
        self.fats100g = fats100g
        self.proteins100g = proteins100g
        self.isAuto = isAuto
        self.$user.id = userID
        self.$foodCategory.id = foodCategoryID
    }
    
    func toResponse() -> FoodResponseDTO {
        FoodResponseDTO(
            id: self.id,
            name: self.name,
            calories100g: self.calories100g,
            carbs100g: self.carbs100g,
            fats100g: self.fats100g,
            proteins100g: self.proteins100g,
            isAuto: self.isAuto,
            userID: self.$user.id,
            foodCategoryID: self.$foodCategory.id
        )
    }
}

