//
//  LoginRequest.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Fluent
import Vapor

struct UserRegisterDTO: Content, Validatable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let weight: Int?
    let size: Int?
    let objective: String?
    let diet: String?
    let gender: String?
    let birthday: Date?
    
    static func validations(_ validations: inout Validations) {
        validations.add("firstName", as: String.self, is: !.empty)
        validations.add("lastName", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

struct LoginRequestDTO: Content, Validatable {
    let email: String
    let password: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: !.empty)
    }
}

struct LoginResponseDTO: Content {
    let token: String
    let user: UserResponseDTO?
}
