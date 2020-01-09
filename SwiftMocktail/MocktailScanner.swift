import Foundation

struct MocktailScanner {
    private var scanner: StringScanner

    init(string: String) {
        scanner = StringScanner(string: string)
    }

    mutating func scanMethod() throws -> HttpMethod {
        return HttpMethod(method: try scan())
    }

    mutating func scanPath() throws -> String {
        return try scan()
    }

    mutating func scanStatusCode() throws -> Int {
        guard let code = Int(try scan()) else {
            throw MocktailError.invalidResponseStatusCode
        }

        return code
    }

    mutating func scanContentType() throws -> String {
        return try scan()
    }

    mutating func scanHeaders() throws -> [String: String] {
        var headers: [String: String] = [:]
        var scanned = scanner.scan(until: "\n")

        while (true) {
            guard let header = scanned, header.count > 0 else {
                break;
            }

            var headerScanner = StringScanner(substring: header)

            guard let name = headerScanner.scan(until: ":")?.trimmingCharacters(in: .whitespaces) else {
                throw MocktailError.invalidHeader
            }

            let value = String(headerScanner.scanUntilEnd().trimmingCharacters(in: .whitespaces))
            headers[String(name)] = value

            scanned = scanner.scan(until: "\n")
        }

        return headers
    }

    mutating func scanBody() throws -> String {
        return String(scanner.scanUntilEnd())
    }

    private mutating func scan() throws -> String {
        guard let scanned = scanner.scan(until: "\n") else {
            throw MocktailError.invalidFormat
        }
        return String(scanned)
    }
}

private struct StringScanner {
    private var string: Substring

    init(string: String) {
        self.string = string[string.startIndex ..< string.endIndex]
    }

    init(substring: Substring) {
        self.string = substring
    }

    mutating func scan(until delimiter: Character) -> Substring? {
        guard let index = string.firstIndex(where: { $0 == delimiter }) else {
            return nil
        }
        let scanned = string.prefix(upTo: index)
        string = string.suffix(from: string.index(after: index))
        return scanned
    }

    mutating func scanUntilEnd() -> Substring {
        let scanned = string
        string = string.prefix(upTo: string.endIndex)
        return scanned
    }
}
