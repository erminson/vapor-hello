@testable import App
import Vapor
import XCTest
import FluentPostgreSQL

final class CategoryTests: XCTestCase {
    let categoryURI = "/api/categories/"
    let categoryName = "Teenager"
    var app: Application!
    var conn: PostgreSQLConnection!
    
    override func setUp() {
        try! Application.reset()
        app = try! Application.testable()
        conn = try! app.newConnection(to: .psql).wait()
    }
    
    override func tearDown() {
        conn.close()
    }
    
    func testCategoriesCanBeRetrievedFromAPI() throws {
        let category = try Category.create(name: categoryName, on: conn)
        _ = try Category.create(on: conn)
        
        let categories = try app.getResponse(to: categoryURI, decodeTo: [App.Category].self)
        
        XCTAssertEqual(categories.count, 2)
        XCTAssertEqual(categories[0].name, categoryName)
        XCTAssertEqual(categories[0].id, category.id)
    }
    
    func testCategoryCanBeSavedWithAPI() throws {
        let category = Category(name: categoryName)
        let receivedCategory = try app.getResponse(to: categoryURI,
                                                   method: .POST,
                                                   headers: ["Content-Type": "application/json"],
                                                   data: category,
                                                   decodeTo: App.Category.self)
        XCTAssertEqual(receivedCategory.name, categoryName)
        XCTAssertNotNil(receivedCategory.id)
        
        let categories = try app.getResponse(to: categoryURI, decodeTo: [App.Category].self)
        
        XCTAssertEqual(categories.count, 1)
        XCTAssertEqual(categories[0].name, categoryName)
        XCTAssertEqual(categories[0].id, receivedCategory.id)
    }
    
    func testGettingASingleCategoryFromApi() throws {
        let category = try Category.create(name: categoryName, on: conn)
        
        let receivedCategory = try app.getResponse(to: "\(categoryURI)\(category.id!)", decodeTo: Category.self)
        
        XCTAssertEqual(receivedCategory.name, categoryName)
        XCTAssertEqual(receivedCategory.id, category.id)
    }
    
    func testGettingCategoriesAcronymsFromAPI() throws {
        let acronymShort = "OMG"
        let acronymLong = "Oh My God"
        let acronym = try Acronym.create(short: acronymShort,
                                         long: acronymLong,
                                         on: conn)
        let acronym2 = try Acronym.create(on: conn)
        
        let category = try Category.create(name: categoryName, on: conn)
        
        _ = try app.sendRequest(to: "/api/acronyms/\(acronym.id!)/categories/\(category.id!)", method: .POST)
        _ = try app.sendRequest(to: "/api/acronyms/\(acronym2.id!)/categories/\(category.id!)", method: .POST)
        
        let acronyms = try app.getResponse(to: "\(categoryURI)\(category.id!)/acronyms", decodeTo: [Acronym].self)
        
        XCTAssertEqual(acronyms.count, 2)
        XCTAssertEqual(acronyms[0].id, acronym.id)
        XCTAssertEqual(acronyms[0].short, acronymShort)
        XCTAssertEqual(acronyms[0].long, acronymLong)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
