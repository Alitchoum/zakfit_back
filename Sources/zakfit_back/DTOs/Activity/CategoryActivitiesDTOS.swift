//
//  ActivityCategories.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Fluent
import Vapor

struct CategoryActivityDTO: Content {
    let name: String
    let picto : String
    let color: String
    let indexOrder: Int
}

struct CategoryActivityResponseDTO: Content {
    let id: UUID?
    let name: String
    let picto : String
    let color: String
    let indexOrder: Int
}

struct CategoryActivityUpdateDTO: Content {
    let name: String?
    let picto : String?
    let color: String?
    let indexOrder: Int?
}

extension CategoryActivityDTO {
    func toModel() -> CategoryActivityDTO {
        return CategoryActivityDTO(name: name, picto: picto, color: color, indexOrder: indexOrder)
    }
}
