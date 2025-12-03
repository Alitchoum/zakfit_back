//
//  CategorieFood.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Fluent
import Vapor

struct CreateFoodCategoryDTO: Content {
    let name: String
    let picto: String
}

struct FoodCategoryResponseDTO: Content {
    let id: UUID?
    let name: String
    let picto: String
}

struct FoodCategoryUpdateDTO: Content{
    let name: String?
    let picto: String?
}
