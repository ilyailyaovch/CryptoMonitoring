import Foundation

// MARK: - CoinGecko API info

/*
 Request URL: ConstantURL.marketDataURL
 JSON Response:
 {
    "data": {
        "active_cryptocurrencies": 11002,
        "upcoming_icos": 0,
        "ongoing_icos": 49,
        "ended_icos": 3376,
        "markets": 931,
        "total_market_cap": {
            "btc": 39486432.6705808,
            "eth": 733497651.4443477,
            "ltc": 20714516973.408943,
            .......
        },
        "total_volume": {
            "btc": 1220091.4505907397,
            "eth": 22664347.043494817,
            "ltc": 640057947.832877,
            .......
        },
        "market_cap_percentage": {
            "btc": 49.502985040308786,
            "eth": 16.39474075858253,
            .......
        },
        "market_cap_change_percentage_24h_usd": 0.4086921752988604,
        "updated_at": 1700412622
    }
 }
 */

// MARK: - quicktype Coin info

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }

    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }

    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }

    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }

}
