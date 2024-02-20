import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "gram_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "gram_password",
        database: Environment.get("DATABASE_NAME") ?? "gram_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateUser())
    
    try await app.autoMigrate().get()
    // register routes
    try routes(app)
}
/*
 docker run --name gram \
 -e POSTGRES_DB=gram_database \
 -e POSTGRES_USER=gram_username \
 -e POSTGRES_PASSWORD=gram_password \
 -p 5432:5432 -d postgres

 */
