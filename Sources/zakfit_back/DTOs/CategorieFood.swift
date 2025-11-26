//
//  CategorieFood.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Fluent
import Vapor

struct FoodCategoryDTO: Content {
    let name: String
    let picto: String
}

struct FoodCategoryResponse: Content {
    let id: UUID?
    let name: String
    let picto: String
}

struct FoodCategoryUpdate: Content{
    let name: String?
    let picto: String?
}

//Ajouter func toModel()
