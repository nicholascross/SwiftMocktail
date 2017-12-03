//
//  SwiftMocktailTests.swift
//  SwiftMocktailTests
//
//  Created by Nick Cross on 29/11/17.
//  Copyright © 2017 Nick Cross. All rights reserved.
//

import XCTest
@testable import SwiftMocktail

class MocktailTests: XCTestCase {
    
    func testNonExistantFile() {
        
        XCTAssertThrowsError(try Mocktail(path: "asdf.tail"))
    }
    
    func testInvalidFile() {
        XCTAssertThrowsError(try Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_invalid", ofType: "tail")!)) { error in
            XCTAssertEqual(error as? MocktailError, MocktailError.invalidMocktailFormat)
            
        }
    }
    
    func testInvalidMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_invalid_method", ofType: "tail")!)
            XCTAssertEqual(mocktail.method, .other("foo"))
            XCTAssertEqual(mocktail.path, "test/path/expres")
            XCTAssertEqual(mocktail.responseStatusCode, 200)
            XCTAssertEqual(mocktail.responseHeaders["Content-Type"], "application/json")
    }
    
    func testInvalidResponseCode() {
        XCTAssertThrowsError(try Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_invalid_response_code", ofType: "tail")!)) { error in
            XCTAssertEqual(error as? MocktailError, MocktailError.invalidResponseCodeFormat)
            
        }
    }
    
    func testGetMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_get", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .httpMethod(.get))
        XCTAssertEqual(mocktail.path, "test/path/expres")
        XCTAssertEqual(mocktail.responseStatusCode, 200)
        XCTAssertEqual(mocktail.responseHeaders["Content-Type"], "application/json")
    }
    
    func testGetHeadersMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_get_more_headers", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .httpMethod(.get))
        XCTAssertEqual(mocktail.path, "test/path/expres")
        XCTAssertEqual(mocktail.responseStatusCode, 200)
        XCTAssertEqual(mocktail.responseHeaders["Content-Type"], "application/json")
        XCTAssertEqual(mocktail.responseHeaders["token"], "123456")
        XCTAssertEqual(mocktail.responseHeaders["auth"], "asdf")
        XCTAssertEqual(mocktail.responseHeaders.count, 3)
    }

    func testPostMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_post", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .httpMethod(.post))
    }

    func testPutMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_put", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .httpMethod(.put))
    }

    func testPatchMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_patch", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .httpMethod(.patch))
    }
    
    func testDeleteMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_delete", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .httpMethod(.delete))
    }

    
    func testOptionsMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_options", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .httpMethod(.options))
    }
    
    func testHeadMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_head", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .httpMethod(.head))
    }
    
    func testEmptyGet() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_get_empty", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .httpMethod(.get))
        XCTAssertEqual(mocktail.responseBody, "")
    }
    
    func testMethodComparisonIsCaseInsensitive() {
        XCTAssertEqual(Method.other("GET"), Method.other("get"))
        XCTAssertEqual(Method.other("GET"), .httpMethod(.get))
        XCTAssertEqual(.httpMethod(.get), Method.other("GET"))
    }
}
