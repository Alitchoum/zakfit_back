//
//  UserDTO.swift
//  zakfit_back
//
//  Created by alize suchon on 24/11/2025.
//

import Fluent
import Vapor

struct UserResponseDTO: Content {
    let id: UUID?
    let firstName: String
    let lastName: String
    let email: String
    let weight: Int?
    let size: Int?
    let objective: String?
    let diet: String?
    let gender: String?
    let birthday: Date?
}

struct UserUpdateDTO: Content, Validatable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
    let weight: Int?
    let size: Int?
    let objective: String?
    let diet: String?
    let gender: String?
    let birthday: Date?
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email, required: false)
        validations.add("password", as: String.self, is: .count(8...), required: false)
    }
}

//Ajouter func toModel()

