import Foundation

public final class HTTPClient {
    public init() {}

    public func getData(urlRequest: String, encoding: String.Encoding = .utf8) {
        let urlRequest = URL(string: urlRequest)
        guard let url = urlRequest else { return }
        print("GET Request: \(url)\n")
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as? URLError {
                print("Error occured.")
                switch error.code {
                case .notConnectedToInternet:
                    print("The Internet connection appears to be offline. Please reconnect")
                case .cannotFindHost:
                    let host = url.host ?? "Unknown"
                    print("Cannot find host \(host)")
                default: print("An error occurred: \(error.localizedDescription)")
                }
            } else if let response = response as? HTTPURLResponse {
                print("Response code: \(response.statusCode)")
                if response.statusCode == 200 {
                    guard let data = data else { return }
                    let dataAsString = String(data: data, encoding: encoding)
                    guard let dataAsString = dataAsString else { return }
                    print(dataAsString)
                } else if response.statusCode == 404 {
                    print("Page not found. Check url request string.")
                }
            }
        }.resume()
    }
}
