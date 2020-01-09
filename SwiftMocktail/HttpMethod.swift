import Foundation

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
