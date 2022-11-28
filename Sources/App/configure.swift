import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor
import WebAuthn

// configures your application
public func configure(_ app: Application) throws {
    app.logger.logLevel = .debug
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(app.sessions.middleware)

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateWebAuthnCredential())

    app.views.use(.leaf)
    app.webAuthn = WebAuthnManager(
        config: WebAuthnConfig(relyingPartyDisplayName: "My Vapor Web App", relyingPartyID: "1", timeout: 60)
    )

    // register routes
    try routes(app)

    try app.autoMigrate().wait()
}
