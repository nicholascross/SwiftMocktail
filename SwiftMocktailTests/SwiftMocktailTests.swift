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
        XCTAssertThrowsError(try HttpStub(stub: "asdf.tail"))
    }
    
    func testInvalidFile() {
        XCTAssertThrowsError(try HttpStub(stub: "test_invalid.tail")) { error in
            XCTAssertEqual(error as? MocktailError, MocktailError.invalidFormat)
        }
    }
    
    func testInvalidMethod() {
        let mocktail = try! HttpStub(stub: "test_invalid_method.tail")
        XCTAssertEqual(mocktail.method, HttpMethod(method: "foo"))
        XCTAssertEqual(mocktail.path, "test/path/expres")
        XCTAssertEqual(mocktail.responseStatusCode, 200)
        XCTAssertEqual(mocktail.responseHeaders["Content-Type"], "application/json")
    }
    
    func testInvalidResponseCode() {
        XCTAssertThrowsError(try HttpStub(stub: "test_invalid_response_code.tail")) { error in
            XCTAssertEqual(error as? MocktailError, MocktailError.invalidResponseStatusCode)            
        }
    }
    
    func testGetMethod() {
        let mocktail = try! HttpStub(stub: "test_get.tail")
        XCTAssertEqual(mocktail.method, .get)
        XCTAssertEqual(mocktail.path, "test/path/expres")
        XCTAssertEqual(mocktail.responseStatusCode, 200)
        XCTAssertEqual(mocktail.responseHeaders["Content-Type"], "application/json")
    }
    
    func testGetHeadersMethod() {
        let mocktail = try! HttpStub(stub: "test_get_more_headers.tail")
        XCTAssertEqual(mocktail.method, .get)
        XCTAssertEqual(mocktail.path, "test/path/expres")
        XCTAssertEqual(mocktail.responseStatusCode, 200)
        XCTAssertEqual(mocktail.responseHeaders["Content-Type"], "application/json")
        XCTAssertEqual(mocktail.responseHeaders["token"], "123456")
        XCTAssertEqual(mocktail.responseHeaders["auth"], "asdf")
        XCTAssertEqual(mocktail.responseHeaders.count, 3)
    }

    func testPostMethod() {
        let mocktail = try! HttpStub(stub: "test_post.tail")
        XCTAssertEqual(mocktail.method, .post)
    }

    func testPutMethod() {
        let mocktail = try! HttpStub(stub: "test_put.tail")
        XCTAssertEqual(mocktail.method, .put)
    }

    func testPatchMethod() {
        let mocktail = try! HttpStub(stub: "test_patch.tail")
        XCTAssertEqual(mocktail.method, .patch)
    }
    
    func testDeleteMethod() {
        let mocktail = try! HttpStub(stub: "test_delete.tail")
        XCTAssertEqual(mocktail.method, .delete)
    }

    func testOptionsMethod() {
        let mocktail = try! HttpStub(stub: "test_options.tail")
        XCTAssertEqual(mocktail.method, .options)
    }
    
    func testHeadMethod() {
        let mocktail = try! HttpStub(stub:"test_head.tail")
        XCTAssertEqual(mocktail.method, .head)
    }
    
    func testEmptyGet() {
        let mocktail = try! HttpStub(stub: "test_get_empty.tail")
        XCTAssertEqual(mocktail.method, .get)
        XCTAssertEqual(mocktail.responseBody, "")
    }
    
    func testMethodComparisonIsCaseInsensitive() {
        XCTAssertEqual(HttpMethod(method: "GET"), HttpMethod(method: "get"))
        XCTAssertEqual(HttpMethod(method: "GET"), .get)
        XCTAssertEqual(.get, HttpMethod(method:"GET"))
    }
}

extension HttpStub {
    init(stub: String) throws {
        try self.init(path: HttpStub.stubURL(for: stub))
    }

    private static func stubURL(for filename: String) -> String {
        // The sandbox must be disabled for this to work
        return URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(filename).path
    }
}
