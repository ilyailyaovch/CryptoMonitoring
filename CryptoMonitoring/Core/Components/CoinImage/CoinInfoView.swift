import SwiftUI

struct CoinInfoView: View {

    let coin: CoinModel

    var body: some View {
        VStack {
            CoinImageView(coin: self.coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CoinInfoView(coin: DeveloperPreview.instance.coin)
}
