import Fluent
import FluentMySQLDriver
import Vapor
import NIOSSL

// configures your application
public func configure(_ app: Application) throws {   
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.trustRoots = .default
    tls.certificateVerification = .noHostnameVerification

    app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tlsConfiguration: tls
    ), as: .mysql)

    // register routes
    try routes(app)
}
