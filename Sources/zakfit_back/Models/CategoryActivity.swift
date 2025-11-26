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
    
    // MARK: - Relation
    
    @Children(for: \.$category)
    var activities: [Activity]
    
    init() {}
    
    init(name: String, picto: String)
    {
        self.name = name
        self.picto = picto
    }
    
    func toResponse() -> CategoryActivityResponseDTO {
        CategoryActivityResponseDTO(
            id: self.id,
            name: self.name,
            picto: self.picto
        )
    }
}
