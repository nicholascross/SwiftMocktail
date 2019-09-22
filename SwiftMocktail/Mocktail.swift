//  Copyright © 2017 Nick Cross. All rights reserved.

import Foundation

public struct Mocktail {
    public let method: Method
    public let path: String
    public let responseStatusCode: Int
    public let responseHeaders: [String:String]
    public let responseBody: String
    
    public init(method: Method, path: String, responseStatusCode: Int, responseHeaders: [String:String], responseBody: String) {
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
        
        let rawMethod: String = mocktailComponents[0].lowercased()
        var method: Method!
        if let httpMethod = HttpMethod(rawValue: rawMethod) {
            method = .httpMethod(httpMethod)
        }
        else {
            method = .other(rawMethod)
        }
        
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

public enum Method: Equatable {
    case httpMethod(HttpMethod)
    case other(String)
    
    public static func ==(lhs: Method, rhs: Method) -> Bool {
        if case .httpMethod(let httpMethodLHS) = lhs, case .httpMethod(let httpMethodRHS) = rhs {
            return httpMethodLHS == httpMethodRHS
        }
        
        if case .other(let methodLHS) = lhs, case .other(let methodRHS) = rhs {
            return methodLHS.lowercased() == methodRHS.lowercased()
        }
        
        if case .other(let methodLHS) = lhs, case .httpMethod(let httpMethodRHS) = rhs {
            return HttpMethod(rawValue: methodLHS.lowercased()) == httpMethodRHS
        }
        
        if case .httpMethod(let httpMethodLHS) = lhs, case .other(let methodRHS) = rhs {
            return httpMethodLHS == HttpMethod(rawValue: methodRHS.lowercased())
        }
        
        return false
    }
}

public enum HttpMethod: String {
    case options
    case get
    case head
    case post
    case put
    case delete
    case patch
    case trace
    case connect
}

public enum MocktailError: Error {
    case invalidMocktailFormat
    case invalidHeaderFormat
    case invalidResponseCodeFormat
}
