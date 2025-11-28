//
//  ActivityController.swift
//  zakfit_back
//
//  Created by alize suchon on 26/11/2025.
//

import Vapor
import Fluent

struct ActivityController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let activities = routes.grouped("activities")
        
        let protected = activities.grouped(JWTMiddleware())
        protected.post("current", use: createActivity)
        protected.get("current", use: getActivities)
        // options:  "categoryFilter=id-activity" "month=yyyy-MM" "durationFilter=0-1h" "sortBy=date" "order=asc"
        protected.patch("current", use: updateActivity)
        protected.delete("current", use: deleteActivity)
    }
    
    //CREATE
    @Sendable
    func createActivity(req: Request) async throws -> ActivityResponseDTO {
        
        try ActivityDTO.validate(content: req)
        let dto = try req.content.decode(ActivityDTO.self)
        
        let payload = try req.auth.require(UserPayload.self) // Charge user connecté
        let activity = dto.toModel(userID: payload.id)
        
        //verif si categorie existe
        guard let _ = try await CategoryActivity.find(dto.categoryId, on: req.db) else {
            throw Abort(.badRequest, reason: "Category not found")
        }
        
        try await activity.save(on: req.db)
        return activity.toResponse()
    }
    
    //GET USER ACTIVITIES + FILTERS + SORT
    @Sendable
    func getActivities(req: Request) async throws -> [ActivityResponseDTO] {
        
        let payload = try req.auth.require(UserPayload.self)
        
        var query = Activity.query(on: req.db)
            .filter(\.$user.$id == payload.id)
        
        //FILTERED BY DURATION (min)
        if let durationFilter = try? req.query.get(String.self, at: "durationFilter"){
            switch durationFilter {
            case "0-1h":
                query = query.filter(\.$duration >= 0)
                query = query.filter( \.$duration <= 60)
            case "1h-3h":
                query = query.filter(\.$duration > 60)
                query = query.filter( \.$duration <= 180)
            case "3h-6h":
                query = query.filter(\.$duration > 180)
                query = query.filter( \.$duration <= 360)
            default :
                break
            }
        }
        
        //FILTERED BY CATEGORY
        if let categoryId = try? req.query.get(UUID.self, at: "categoryFilter"){
            query = query.filter(\.$category.$id == categoryId)
        }
        
        //FILTERED BY MONTH
        if let monthFilter = try? req.query.get(String.self, at: "month") { //format yyyy-MM
            let split = monthFilter.split(separator: "-")
            let year = Int(split[0])!
            let month = Int(split[1])!
            
            let calendar = Calendar.current
            
            //calcul pour trouver 1er jour du mois
            let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
            //calcul pour trouver 1er jour du mois suivant
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            
            query = query.filter(\.$date >= startOfMonth)
            query = query.filter(\.$date < endOfMonth)
            
        }
        
        //SORT (DATE / ACTIVITY / DURATION)
        let sortBy: String? = try? req.query.get(String.self, at: "sortBy")  //date/category/durée
        let order: String? = try? req.query.get(String.self, at: "order")    // asc/desc"
        
        if let sortBy = sortBy, let order = order {
            switch (sortBy, order) {
            case ("date", "asc"):
                query = query.sort(\.$date, .ascending)
                
            case ("date", "desc"):
                query = query.sort(\.$date, .descending)
                
            case ("category", "asc"):
                query = query.join(CategoryActivity.self, on: \Activity.$category.$id == \CategoryActivity.$id)
                query = query.sort(CategoryActivity.self, \.$name, .ascending)
                
            case ("category", "desc"):
                query = query.join(CategoryActivity.self, on: \Activity.$category.$id == \CategoryActivity.$id)
                query = query.sort(CategoryActivity.self, \.$name, .descending)
                
            case ("duration", "asc"):
                query = query.sort(\.$duration, .ascending)
                
            case ("duration", "desc"):
                query = query.sort(\.$duration, .descending)
                
            default:
                break
            }
        }
        
        let activities = try await query.all()
        
        return activities.map{$0.toResponse()}
    }
    
    //UPDATE ACTIVITY -> adapter pour user !
    @Sendable
    func updateActivity(req: Request) async throws -> ActivityResponseDTO{
                
        guard let activity = try await Activity.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound, reason : "Activity not found")
        }
        
        let updateData = try req.content.decode(ActivityUpdateDTO.self)

        if let duration = updateData.duration {activity.duration = duration}
        if let caloriesBurned = updateData.caloriesBurned {activity.caloriesBurned = caloriesBurned}
        if let categoryId = updateData.categoryId {activity.$category.id = categoryId}
        if let date = updateData.date {activity.date = date}
        
        try await activity.update(on: req.db)
        return activity.toResponse()
    }
    
    //DELETE ACTIVITY -> adapter pour user !
    @Sendable
    func deleteActivity(req: Request) async throws -> HTTPStatus{
        guard let activity = try await Activity.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound, reason : "Activity not found")
        }
        try await activity.delete(on: req.db)
        return .noContent
    }
   
    
}

