import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {

    //MARK: - CORS

        let corsConfig = CORSMiddleware.Configuration(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .PUT, .DELETE, .PATCH, .OPTIONS,],
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent],
            allowCredentials: true,
            cacheExpiration: 3600
        )

    let cors = CORSMiddleware(configuration: corsConfig)
    app.middleware.use(cors)
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "127.0.0.1",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 3306,
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "zakfitdb"
    ), as: .mysql)

    
    //MARK: - Migrations
    app.migrations.add(CreateUser())

    app.migrations.add(CreateCategoryActivities())
    app.migrations.add(CreateActivity())
    
    app.migrations.add(CreateNutritionGoal())
    app.migrations.add(CreatePhysicalGoal())
    
    app.migrations.add(CreateFoodCategory())
    app.migrations.add(CreateFood())
    app.migrations.add(CreateMeal())
    app.migrations.add(CreateFoodMeal())
    
    try await app.autoMigrate()
    try routes(app)
}
