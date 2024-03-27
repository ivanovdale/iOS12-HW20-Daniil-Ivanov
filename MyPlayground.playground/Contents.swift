import Foundation

// MARK: - Use case

let client = HTTPClient()

// MARK: - Get currency data

let cbrApi = CBRApi(client: client)
let currentDate = Date.getCurrentDate()
cbrApi.getCurrencyExchangeList(dateString: currentDate)
cbrApi.getFakeResource()
cbrApi.getHostNotFound()
cbrApi.getCurrencyExchangeListWithBadParameter()

// MARK: - Get marvel data

let marvelApi = MarvelApi(client: client)
marvelApi.getComicsOfCharacter(id: "1011424")
