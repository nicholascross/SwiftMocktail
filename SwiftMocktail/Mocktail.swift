//  Copyright © 2017 Nick Cross. All rights reserved.

import Foundation

public struct Mocktail {
    public let method: HttpMethod
    public let path: String
    public let responseStatusCode: Int
    public let responseHeaders: [String:String]
    public let responseBody: String
    
    public init(method: HttpMethod, path: String, responseStatusCode: Int, responseHeaders: [String:String], responseBody: String) {
        self.method = method
        self.path = path
        self.responseStatusCode = responseStatusCode
        self.responseHeaders = responseHeaders
        self.responseBody = responseBody
    }
    
    public init(path: String) throws {
        try self.init(string: try String(contentsOfFile: path))
    }
    
    public init(string: String) throws {
        let components = string.components(separatedBy: "\n\n")
        guard let mocktailComponents = components.first?.components(separatedBy: "\n") else {
                throw MocktailError.invalidMocktailFormat
        }
        
        let responseBody: String = components.count > 1 ? components[1] : ""
        
        guard mocktailComponents.count >= 4 else {
            throw MocktailError.invalidMocktailFormat
        }

        let method: HttpMethod = HttpMethod(method: mocktailComponents[0])
        let path: String = mocktailComponents[1]
        
        guard let responseStatusCode: Int = Int(mocktailComponents[2]) else {
            throw MocktailError.invalidResponseCodeFormat
        }
        
        var responseHeaders: [String:String] = [
            "Content-Type" : mocktailComponents[3]
        ]
        
        for index in 4..<mocktailComponents.count {
            let headerValue = mocktailComponents[index].components(separatedBy: ":")
            guard let header = headerValue.first?.trimmingCharacters(in: .whitespaces),
                let value = headerValue.last?.trimmingCharacters(in: .whitespaces) else {
                    throw MocktailError.invalidHeaderFormat
            }
            
            responseHeaders[header] = value
        }
        
        self.init(method: method, path: path, responseStatusCode: responseStatusCode, responseHeaders: responseHeaders, responseBody: responseBody)
    }
}

public struct HttpMethod: CustomStringConvertible, Equatable {
    var method: String

    public static let options = HttpMethod(method: "options")
    public static let get = HttpMethod(method: "get")
    public static let head = HttpMethod(method: "head")
    public static let post = HttpMethod(method: "post")
    public static let put = HttpMethod(method: "put")
    public static let delete = HttpMethod(method: "delete")
    public static let patch = HttpMethod(method: "patch")
    public static let trace = HttpMethod(method: "trace")
    public static let connect = HttpMethod(method: "connect")

    public init(method: String) {
        self.method = method.lowercased()
    }

    public var description: String {
        return method
    }
}

public enum MocktailError: Error {
    case invalidMocktailFormat
    case invalidHeaderFormat
    case invalidResponseCodeFormat
}

