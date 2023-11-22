import Foundation
import Combine

class CoinDataService {

    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?

    init() {
        getCoins()
    }

    func getCoins() {

        let urlString = ConstantURL.coinDataURL
        guard let url = URL(string: urlString) else { return }

        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}

//            .sink { (completion) in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] (returnedCoins) in
//                self?.allCoins = returnedCoins
//                self?.coinSubscription?.cancel()
//            }
