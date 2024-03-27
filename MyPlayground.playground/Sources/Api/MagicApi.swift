import Foundation

public final class MagicApi {
    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    private enum Endpoint {
        case cards(name: String)

        var urlRequest: String {
            var components = URLComponents()
            components.scheme = Constants.scheme
            components.host = Constants.host

            switch self {
            case .cards(let name):
                components.path = Constants.cardsResource
                components.queryItems = buildQueryItems(name: name)
                return components.url?.absoluteString ?? ""
            }
        }

        private func buildQueryItems(name: String) -> [URLQueryItem] {
            [URLQueryItem(name: "name", value: name)]
        }
    }

    public func getCardByName(name: String) {
        client.getData(urlRequest: Endpoint.cards(name: name).urlRequest)
    }
}

// MARK: - Constants

fileprivate enum Constants {
    static let scheme = "https"
    static let host = "api.magicthegathering.io"
    static let cardsResource = "/v1/cards"
}
