//
//  FoodMeal.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Vapor
import Fluent

final class FoodMeal: Model, Content, @unchecked Sendable{
    static let schema = "food_meals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "quantity")
    var quantity: Int
    
    // MARK: - Relation
    
    @Parent(key :"meal_id")
    var meal: Meal
    
    @Parent(key :"food_id")
    var food: Food
    
    init(){}
    
    init(quantity: Int, mealID: Meal.IDValue, foodID: Food.IDValue) {
        self.quantity = quantity
        self.$meal.id = mealID
        self.$food.id = foodID
    }
}
