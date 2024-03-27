import Foundation

let client = HTTPClient()
let magicApi = MagicApi(client: client)
magicApi.getCardByName(name: "Black Lotus")
