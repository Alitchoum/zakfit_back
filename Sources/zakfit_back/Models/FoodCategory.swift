//
//  FoodCategory.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Vapor
import Fluent

final class FoodCategory: Model, Content, @unchecked Sendable {
    static let schema = "food_categories"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "picto")
    var picto: String
    
    @Children(for: \.$foodCategory)
    var foods: [Food]
    
    init() { }
    init(name: String, picto: String) {
        self.name = name
        self.name = picto
    }
    
    func toResponse() -> FoodCategoryResponse {
        FoodCategoryResponse(
            id: id.self,
            name: self.name,
            picto: self.picto
        )
    }
}
