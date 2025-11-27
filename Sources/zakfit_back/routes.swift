import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    try app.register(collection: AuthController())
    try app.register(collection: UserController())
    
    try app.register(collection: CategoryActivitiesController())
    try app.register(collection: ActivityController())
    
    try app.register(collection: NutritionGoalController())
    try app.register(collection: PhysicalGoalController())
    
    try app.register(collection: FoodCategoryController())
    try app.register(collection: FoodController())
    try app.register(collection: MealController())
    try app.register(collection: FoodMealController())
}
