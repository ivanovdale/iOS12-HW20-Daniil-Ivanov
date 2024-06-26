import Foundation

public enum HTTPClientError: Error {
    case serverError(ServerError)
    case noParsingData
    case parsingError
    case cantBuildJWTBody
    case wrongURL
}
