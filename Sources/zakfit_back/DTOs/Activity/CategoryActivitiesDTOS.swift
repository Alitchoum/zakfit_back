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
}

struct CategoryActivityResponseDTO: Content {
    let id: UUID?
    let name: String
    let picto : String
}

struct CategoryActivityUpdateDTO: Content {
    let name: String?
    let picto : String?
}

extension CategoryActivityDTO {
    func toModel() -> CategoryActivityDTO {
        return CategoryActivityDTO(name: name, picto: picto)
    }
}
