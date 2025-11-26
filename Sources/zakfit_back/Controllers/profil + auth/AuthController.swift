//
//  AuthController.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Vapor
import Fluent
import JWT

struct AuthController: RouteCollection  {
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        
        auth.post("register", use: registerUser)
        auth.post("login", use: loginUser)
        
    }
    
    //REGISTER
    @Sendable
    func registerUser(req: Request) async throws -> UserResponseDTO {
        
        //Verifs password > 8 et email format
        try UserRegisterDTO.validate(content: req)
        
        let dto = try req.content.decode(UserRegisterDTO.self)
        
        //Verif si email déjà utilisé
        let checkEmail = try await User.query(on: req.db)
            .filter(\.$email == dto.email)
            .first()
        guard checkEmail == nil else {
            throw Abort(.badRequest, reason: "Email already exist.")
        }
        
        let user = User(
            firstName: dto.firstName,
            lastName: dto.lastName,
            email: dto.email,
            password: try Bcrypt.hash(dto.password),
            weight: dto.weight,
            size: dto.size,
            objective: dto.objective,
            diet: dto.diet,
            gender: dto.gender,
            birthday: dto.birthday
        )
        
        try await user.save(on: req.db)
        return user.toResponse()
    }
    
    //LOGIN
    @Sendable
    func loginUser(req: Request) async throws -> LoginResponseDTO {
        
        try LoginRequestDTO.validate(content: req)
        
        let userData = try req.content.decode(LoginRequestDTO.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "User does't exist.")
        }
        guard try Bcrypt.verify(userData.password, created: user.password) else {
            throw Abort(.unauthorized, reason: "Password incorrect.")
        }
        let payload =  UserPayload(id: user.id!)
        let signer = JWTSigner.hs256(key: "zakfit2025")
        let token = try signer.sign(payload)
        return LoginResponseDTO(
            token: token,
            user: user.toResponse()
        )
    }
}
