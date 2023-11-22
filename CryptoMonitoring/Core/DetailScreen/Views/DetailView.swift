import SwiftUI

struct DetailLoadingView: View {

    @Binding var coin: CoinModel?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {

    let coin: CoinModel

    init(coin: CoinModel) {
        self.coin = coin
    }

    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailLoadingView(coin: .constant(DeveloperPreview.instance.coin))
    // DetailView(coin: DeveloperPreview.instance.coin)
}
