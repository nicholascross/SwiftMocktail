//  Copyright © 2017 Nick Cross. All rights reserved.

import Foundation

open class Mocktail {
    let method: HttpMethod
    let path: NSRegularExpression
    let responseStatusCode: Int
    let responseHeaders: [String:String]
    let responseBody: String
    
    public init(method: HttpMethod, path: NSRegularExpression, responseStatusCode: Int, responseHeaders: [String:String], responseBody: String) {
        self.method = method
        self.path = path
        self.responseStatusCode = responseStatusCode
        self.responseHeaders = responseHeaders
        self.responseBody = responseBody
    }
    
    public convenience init(path: String) throws {
        try self.init(string: try String(contentsOfFile: path))
    }
    
    public convenience init(string: String) throws {
        let components = string.components(separatedBy: "\n\n")
        guard let mocktailComponents = components.first?.components(separatedBy: "\n") else {
                throw MocktailError.invalidMocktailFormat
        }
        
        let responseBody: String = components.count > 1 ? components[1] : ""
        
        guard mocktailComponents.count >= 4 else {
            throw MocktailError.invalidMocktailFormat
        }
        
        guard let method: HttpMethod = HttpMethod(rawValue: mocktailComponents[0].lowercased()) else {
            throw MocktailError.invalidMethodFormat
        }
        
        guard let path: NSRegularExpression = try? NSRegularExpression(pattern: mocktailComponents[1], options: []) else {
            throw MocktailError.invalidPathFormat
        }
        
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

public enum HttpMethod: String {
    case options
    case get
    case head
    case post
    case put
    case patch
    case delete
}

public enum MocktailError: Error {
    case invalidMocktailFormat
    case invalidHeaderFormat
    case invalidPathFormat
    case invalidMethodFormat
    case invalidResponseCodeFormat
}
