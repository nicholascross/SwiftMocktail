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
        XCTAssertThrowsError(try Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_invalid_method", ofType: "tail")!)) { error in
            XCTAssertEqual(error as? MocktailError, MocktailError.invalidMethodFormat)
            
        }
    }
    
    func testInvalidResponseCode() {
        XCTAssertThrowsError(try Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_invalid_response_code", ofType: "tail")!)) { error in
            XCTAssertEqual(error as? MocktailError, MocktailError.invalidResponseCodeFormat)
            
        }
    }
    
    func testGetMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_get", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .get)
        XCTAssertEqual(mocktail.path.pattern, "test/path/expres")
        XCTAssertEqual(mocktail.responseStatusCode, 200)
        XCTAssertEqual(mocktail.responseHeaders["Content-Type"], "application/json")
    }
    
    func testGetHeadersMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_get_more_headers", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .get)
        XCTAssertEqual(mocktail.path.pattern, "test/path/expres")
        XCTAssertEqual(mocktail.responseStatusCode, 200)
        XCTAssertEqual(mocktail.responseHeaders["Content-Type"], "application/json")
        XCTAssertEqual(mocktail.responseHeaders["token"], "123456")
        XCTAssertEqual(mocktail.responseHeaders["auth"], "asdf")
        XCTAssertEqual(mocktail.responseHeaders.count, 3)
    }

    func testPostMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_post", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .post)
    }

    func testPutMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_put", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .put)
    }

    func testPatchMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_patch", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .patch)
    }
    
    func testDeleteMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_delete", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .delete)
    }

    
    func testOptionsMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_options", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .options)
    }
    
    func testHeadMethod() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_head", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .head)
    }
    
    func testEmptyGet() {
        let mocktail = try! Mocktail(path: Bundle(for: MocktailTests.self).path(forResource: "test_get_empty", ofType: "tail")!)
        XCTAssertEqual(mocktail.method, .get)
        XCTAssertEqual(mocktail.responseBody, "")
    }
}
