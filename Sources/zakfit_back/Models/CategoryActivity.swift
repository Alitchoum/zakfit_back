//
//  Activity_category.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Vapor
import Fluent

final class CategoryActivity: Model, Content, @unchecked Sendable {
    static let schema = "activity_categories"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "picto")
    var picto : String
    
    @Field(key: "color")
    var color : String
    
    @Field(key: "index_order")
    var indexOrder: Int
    
    // MARK: - Relation
    
    @Children(for: \.$category)
    var activities: [Activity]
    
    init() {}
    
    init(name: String, picto: String, color: String, indexOrder: Int)
    {
        self.name = name
        self.picto = picto
        self.color = color
        self.indexOrder = indexOrder
    }
    
    func toResponse() -> CategoryActivityResponseDTO {
        CategoryActivityResponseDTO(
            id: self.id,
            name: self.name,
            picto: self.picto,
            color: self.color,
            indexOrder: self.indexOrder
        )
    }
}
