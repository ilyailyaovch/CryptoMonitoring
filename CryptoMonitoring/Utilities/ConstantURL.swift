import Foundation

enum ConstantURL {
    static let coinGeckoDocumentationPageURL = "https://www.coingecko.com/api/documentation"
    static let coinGeckoPingURL = "https://api.coingecko.com/api/v3/ping"
    static let marketDataURL = "https://api.coingecko.com/api/v3/global"
    static let coinDataURL =
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    static let coinDetailBitcoinURL = "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
}
