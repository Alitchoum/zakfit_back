import Fluent
import Vapor

func routes(_ app: Application) throws {
    
//    routes.get("test") { req -> String in
//        let payload = try req.auth.require(UserPayload.self)
//        return "Hello \(payload.id!)"
//    }
//    
    try app.register(collection: AuthController())
    try app.register(collection: UserController())
    try app.register(collection: CategoryActivitiesController())
    try app.register(collection: ActivityController())
}
