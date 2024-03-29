import Foundation

let client = HTTPClient()
let magicApi = MagicApi(client: client)
let completion: ObjectEndpointCompletion<Cards> = { result, _ in
    switch result {
    case .success(let cards):
        print("Карты:\n\(cards)")

    case .failure(let error):
        print(error)
    }
}

magicApi.getCardsByName(name: "Black Lotus", completion: completion)
magicApi.getCardsByName(name: "\"Opt\"", completion: completion)
