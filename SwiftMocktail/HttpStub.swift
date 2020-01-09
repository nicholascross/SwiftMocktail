import Foundation

public struct HttpStub {
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
        var scanner = MocktailScanner(string: string)
        let method = try scanner.scanMethod()
        let path = try scanner.scanPath()
        let statusCode = try scanner.scanStatusCode()
        let contentType = try scanner.scanContentType()
        var headers = try scanner.scanHeaders()
        let body = try scanner.scanBody()

        headers["Content-Type"] = contentType

        self.init(method: method, path: path, responseStatusCode: statusCode, responseHeaders: headers, responseBody: body)
    }
}
