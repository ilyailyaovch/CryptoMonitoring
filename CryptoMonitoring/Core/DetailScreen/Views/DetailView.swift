import SwiftUI

struct DetailLoadingView: View {

    @Binding var coin: CoinModel?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            } else {
                ProgressView()
            }
        }
    }
}

struct DetailView: View {

    @StateObject private var vm: DetailViewModel
    private let gridSpacing: CGFloat = 30
    private let gridColumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(coin: CoinModel) {
        self._vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ProgressView().frame(height: 150)
                OverviewTitle
                Divider()
                OverviewBody
                AdditionalTitle
                Divider()
                AdditionalBody
            }.padding()
        }.navigationTitle(vm.coin.name)
    }
}

extension DetailView {
    private var OverviewTitle: some View {
        Text("Details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var OverviewBody: some View {
        LazyVGrid(
            columns: gridColumns,
            alignment: .leading,
            spacing: gridSpacing,
            content: {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            })
    }
    private var AdditionalTitle: some View {
        Text("Additional details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var AdditionalBody: some View {
        LazyVGrid(
            columns: gridColumns,
            alignment: .leading,
            spacing: gridSpacing,
            content: {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            })
    }
}

#Preview {
    NavigationView {
        DetailLoadingView(coin: .constant(DeveloperPreview.instance.coin))
    }
}
