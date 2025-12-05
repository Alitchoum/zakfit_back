//
//  UserController.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Vapor
import Fluent
import JWT

struct UserController: RouteCollection  {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        users.get(use: getAllUsers)
        users.get(":id", use: getUserByID)
        
        let protected = users.grouped(JWTMiddleware())
        protected.get("profile", use: userProfile)
        protected.patch("profile", use: updateUserProfile)
        protected.delete("profile", use: deleteUser)
    }
    
    //GET USER PROFIL
    @Sendable
    func userProfile(req: Request) async throws -> UserResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        return user.toResponse()
    }
    
    //GET ALL (admin)
    @Sendable
    func getAllUsers(req: Request) async throws -> [UserResponseDTO] {
        let users = try await User.query(on: req.db).all()
        return users.map{$0.toResponse()}
    }
    
    //GET BY ID (admin)
    @Sendable
    func getUserByID(req: Request) async throws -> UserResponseDTO {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        return user.toResponse()
    }
    
    //UPDATE USER PROFIL
    @Sendable
    func updateUserProfile(req: Request) async throws -> UserResponseDTO {
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        //Charge les datas a changer
        try UserUpdateDTO.validate(content: req)
        let updateData = try req.content.decode(UserUpdateDTO.self)
        
        if let firstName = updateData.firstName {user.firstName = firstName }
        if let lastName = updateData.lastName {user.lastName = lastName }
        
        //Verif Email Unique
        if let newEmail = updateData.email, newEmail != user.email {
            let checkEmail = try await User.query(on: req.db)
                .filter(\.$email == newEmail)
                .first()
            
            if checkEmail != nil {
                throw Abort(.badRequest, reason: "Email already in use.")
            }
            user.email = newEmail
        }
        
        if let newPassword = updateData.password { user.password = try Bcrypt.hash(newPassword)}
        if let weight = updateData.weight { user.weight = weight}
        if let size = updateData.size { user.size = size}
        if let objective = updateData.objective { user.objective = objective}
        if let diet = updateData.diet { user.diet = diet}
        if let gender = updateData.gender { user.gender = gender}
        if let birthday = updateData.birthday { user.birthday = birthday}
        
        try await user.save(on: req.db)
        return user.toResponse()
        
    }
    
    //DELETE USER
    @Sendable
    func deleteUser(req: Request) async throws -> HTTPStatus {
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        //SUPPRIME ACTIVITÉS USER
        let activities = try await user.$activities.query(on: req.db).all()
        for activity in activities {
            try await activity.delete(on: req.db)
        }
        
        //SUPPRIME MEALS + FOODMEALS LIÉS
        let meals = try await user.$meals.query(on: req.db).all()
        for meal in meals {
            let foodMeals = try await meal.$foodMeals.query(on: req.db).all()
            for foodMeal in foodMeals {
                try await foodMeal.delete(on: req.db)
            }
            try await meal.delete(on: req.db)
        }
        
        //SUPPRIME FOOD PERSO USER + FOOMEALS
        let Userfoods = try await user.$foods.query(on: req.db).all()
        for food in Userfoods {
            
            let foodMeals = try await food.$foodMeals.query(on: req.db).all()
            for foodMeal in foodMeals {
                try await foodMeal.delete(on: req.db)
            }
            try await food.delete(on: req.db)
        }
        
        try await user.delete(on: req.db)
        return .noContent
    }
}
