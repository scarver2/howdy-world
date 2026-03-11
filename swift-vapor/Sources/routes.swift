// swift-vapor/Sources/App/Routes/routes.swift
import Vapor

func routes(_ app: Application) throws {

    let home = HomeController()

    app.get("/", use: home.index)

}
