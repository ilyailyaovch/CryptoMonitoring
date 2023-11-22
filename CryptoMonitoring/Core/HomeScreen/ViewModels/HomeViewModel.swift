import Foundation
import Combine

class HomeViewModel: ObservableObject {

    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()

    enum SortOption {
        case rank, rankReversed
        case holdings, holdingsReversed
        case price, priceReversed
    }

    init() {
        self.addSubscribers()
    }

    /// Gets allCoins, portfolioCoins, statistics
    func addSubscribers() {
        // Updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        // Updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntitise)
            .map(mapPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        // Updates statistics
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

    /// Refreshes portfolio after changes
    func updatePortfolio(coin: CoinModel, amount: Double) {
        self.portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    /// Refreshes coins prices and persentage
    func updateCoinsData() {
        isLoading = true
        self.coinDataService.getCoins()
        self.marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }

    ///  For updating and sorting allCoins
    private func filterAndSortCoins(text: String, coins: [CoinModel] ,sort: SortOption) -> [CoinModel] {
        var allCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &allCoins)
        return allCoins
    }

    ///  For updating allCoins
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }

    ///  For sorting allCoins
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings: coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed: coins.sort(by: { $0.rank > $1.rank })
        case . price: coins.sort(by: { $0.currentPrice < $1.currentPrice })
        case . priceReversed: coins.sort(by: { $0.currentPrice > $1.currentPrice })
        }
    }

    ///  For sorting portfolioCoins only by holdings
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings: return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed: return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default: return coins
        }
    }

    ///  For updating portfolioCoins
    private func mapPortfolioCoins(coinModels: [CoinModel], portfoloiEntities: [PortfolioEntity]) -> [CoinModel] {
        return coinModels.compactMap { (coin) -> CoinModel? in
            guard let entity = portfoloiEntities.first(where: { $0.coinID == coin.id}) else { return nil }
            return coin.updateHoldings(amount: entity.amount)
        }
    }

    ///  For updating marketData
    private func mapMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else { return stats }
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentageChange = coin.priceChangePercentage24H ?? 0 / 100
            let previousValue = currentValue / (1 + percentageChange)
            return previousValue
        }.reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        let marketCap = StatisticModel(
            title: "Market Cap",
            value: data.marketCap,
            percentageChange: data.marketCapChangePercentage24HUsd
        )
        let volume = StatisticModel(
            title: "24h Volume",
            value: data.volume
        )
        let btcDominance = StatisticModel(
            title: "BTC Dominance",
            value: data.btcDominance
        )
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }

}
