import Foundation

public typealias ObjectEndpointCompletion<Object: Decodable> = (Result<Object, Error>,
                                                                HTTPURLResponse?) -> ()

public final class HTTPClient {
    public init() {}

    public func getData<Object: Decodable>(urlRequest: String, 
                                           encoding: String.Encoding = .utf8,
                                           completion: @escaping ObjectEndpointCompletion<Object>) {

        let urlRequest = URL(string: urlRequest)
        guard let url = urlRequest else { return }

        print("GET Request: \(url)\n")

        URLSession.shared.dataTask(with: url) { data, response, error in

            // MARK: - Error handling

            if let error = error as? URLError {
                print("Error occured.")

                switch error.code {
                case .notConnectedToInternet:
                    completion(.failure(HTTPClientError.serverError(ServerError.networkProblem)), nil)
                case .cannotFindHost:
                    completion(.failure(HTTPClientError.wrongURL), nil)
                default:
                    completion(.failure(HTTPClientError.serverError(ServerError.serverFail)), nil)
                }
            } else if let response = response as? HTTPURLResponse {
                print("Response code: \(response.statusCode)")

                // MARK: - OK response handling

                if response.statusCode == 200 {
                    guard let data = data else { return }
                    
                    // MARK: - Data mapping

                    do {
                        let objects = try self.mapToModel(Object.self, data: data)

                        self.mainAsync {
                            completion(.success(objects), response)
                        }

                    } catch {

                        // MARK: - Data mapping error

                        self.mainAsync {
                            print("Unexpected error: \(error).")
                            completion(.failure(HTTPClientError.serverError(ServerError.serverFail)), response)
                        }
                    }
                } else if response.statusCode == 404 {
                    self.mainAsync {
                        completion(.failure(HTTPClientError.wrongURL), nil)
                    }
                }
            }
        }.resume()
    }

    // MARK: - Data mapper

    private func mapToModel<D: Decodable>(_ type: D.Type,
                                   data: Data?) throws -> D
    {
        guard let data = data else { throw HTTPClientError.noParsingData }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(D.self, from: data)
        } catch {
            throw error
        }
    }

    // MARK: - Main async queue worker

    private func mainAsync(block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
}
