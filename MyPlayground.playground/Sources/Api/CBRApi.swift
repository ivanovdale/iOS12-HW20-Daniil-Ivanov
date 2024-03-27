import Foundation

public final class CBRApi {
    private enum Constants {
        static let scheme = "https"
        static let host = "www.cbr.ru"
        static let fakeHost = "www.cb.ru"
    }

    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    private enum Endpoint {
        case currencyExchangeList(dateString: String)
        case fakeResource
        case hostNotFound
        case currencyExchangeListWithBadParameter

        var urlRequest: String {
            var components = URLComponents()
            components.scheme = Constants.scheme
            components.host = Constants.host

            switch self {
            case .currencyExchangeList(let dateString):
                components.path = "/scripts/XML_daily.asp"
                components.queryItems = buildQueryItems(dateString: dateString)
                return components.url?.absoluteString ?? ""
            case .fakeResource:
                components.path = "/sc/XML_daily.asp"
                return components.url?.absoluteString ?? ""
            case .hostNotFound:
                components.host = Constants.fakeHost
                components.path = "/scripts/XML_daily.asp"
                return components.url?.absoluteString ?? ""
            case .currencyExchangeListWithBadParameter:
                components.path = "/scripts/XML_daily.asp"
                components.queryItems = buildQueryItems(dateString: "01/01/1970")
                return components.url?.absoluteString ?? ""
            }
        }

        private func buildQueryItems(dateString: String) -> [URLQueryItem] {
            [URLQueryItem(name: "date_req", value: dateString)]
        }
    }

    public func getCurrencyExchangeList(dateString: String) {
        client.getData(urlRequest: Endpoint.currencyExchangeList(dateString: dateString).urlRequest, encoding: .windowsCP1251)
    }

    public func getFakeResource() {
        client.getData(urlRequest: Endpoint.fakeResource.urlRequest, encoding: .windowsCP1251)
    }

    public func getHostNotFound() {
        client.getData(urlRequest: Endpoint.hostNotFound.urlRequest, encoding: .windowsCP1251)
    }

    public func getCurrencyExchangeListWithBadParameter() {
        client.getData(urlRequest: Endpoint.currencyExchangeListWithBadParameter.urlRequest, encoding: .windowsCP1251)
    }

}
