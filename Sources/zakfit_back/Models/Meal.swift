//
//  Meal.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Vapor
import Fluent

final class Meal: Model, Content, @unchecked Sendable {
    static let schema = "meals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "type")
    var type: String
    
    @OptionalField(key: "image")
    var image: String?
    
    @Field(key: "total_calories")
    var totalCalories: Double
    
    @Field(key: "total_proteins")
    var totalProteins: Double
    
    @Field(key: "total_carbs")
    var totalCarbs: Double
    
    @Field(key: "total_fats")
    var totalFats: Double
    
    @Field(key: "date")
    var date: Date
    
    // MARK: - Relations
    
    @Parent(key: "user_id")
    var user : User
    
    //lien avec table pivot -> acces quantité
    @Children(for: \.$meal)
    var foodMeals: [FoodMeal]
    
    //créer lien table food vers table meal via table food_meal - lien aliments contenus dans un repas
    @Siblings(through: FoodMeal.self, from: \.$meal, to: \.$food)
    var foods: [Food]
    
    init() {}
    
    init(type: String, image: String? = nil, totalCalories: Double, totalProteins: Double, totalCarbs: Double, totalFats: Double, date: Date, userID: UUID)
    {
        self.type = type
        self.image = image
        self.totalCalories = totalCalories
        self.totalProteins = totalProteins
        self.totalCarbs = totalCarbs
        self.totalFats = totalFats
        self.date = date
        self.$user.id = userID
    }
    
    func toResponse() -> MealResponseDTO {
        return MealResponseDTO(
            id: self.id,
            type: self.type,
            totalCalories: self.totalCalories,
            totalProteins: self.totalProteins,
            totalCarbs: self.totalCarbs,
            totalFats: self.totalFats,
            date: self.date,
            userId: self.$user.id
        )
    }
    
    func toMealWithFoodsResponse() -> MealWithFoodsResponseDTO {
        let foodItems = self.foodMeals.map { fm in
            FoodInMealResponseDTO(
                id: fm.id!,
                name: fm.food.name,
                quantity: fm.quantity,
                calories: fm.food.calories100g * Double(fm.quantity) / 100,
                carbs: fm.food.carbs100g * Double(fm.quantity) / 100,
                proteins: fm.food.proteins100g * Double(fm.quantity) / 100,
                fats: fm.food.fats100g * Double(fm.quantity) / 100
            )
        }
        
        return MealWithFoodsResponseDTO(
            id: self.id,
            type: self.type,
            totalCalories: self.totalCalories,
            totalProteins: self.totalProteins,
            totalCarbs: self.totalCarbs,
            totalFats: self.totalFats,
            date: self.date,
            userId: self.$user.id,
            foods: foodItems
        )
    }
}
