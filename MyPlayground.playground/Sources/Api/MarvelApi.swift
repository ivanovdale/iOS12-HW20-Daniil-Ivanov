import Foundation

public final class MarvelApi {
    private enum Constants {
        static let scheme = "https"
        static let host = "gateway.marvel.com"
        static let publicApiKey = "4c43dd559df35e4102ed9be981186419"
        static let privateApiKey = "34910bd2da65fd23a364ce6cdcf370072560a28e"
    }

    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    private enum Endpoint {
        case characterComics(id: String)

        var urlRequest: String {
            switch self {
            case .characterComics(let id):
                var components = URLComponents()
                components.scheme = Constants.scheme
                components.host = Constants.host
                components.path = "/v1/public/characters/\(id)/comics"
                components.queryItems = buildQueryItems()

                return components.url?.absoluteString ?? ""
            }
        }

        private func buildQueryItems() -> [URLQueryItem] {
            let timestamp = String(Date().currentTimeInMillis())
            let hashValue = (timestamp + Constants.privateApiKey + Constants.publicApiKey).md5Hash()

            return [
                URLQueryItem(name: "apikey", value: Constants.publicApiKey),
                URLQueryItem(name: "ts", value: timestamp),
                URLQueryItem(name: "hash", value: hashValue)
            ]
        }
    }

    public func getComicsOfCharacter(id: String) {
        client.getData(urlRequest: Endpoint.characterComics(id: id).urlRequest)
    }
}
