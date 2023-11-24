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
    @State private var showFullDescription: Bool = false
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
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    OverviewTitle
                    Divider()
                    DescriptionSection
                    OverviewBody
                    AdditionalTitle
                    Divider()
                    AdditionalBody
                    LinksTitle
                    Divider()
                    LinksBody
                }.padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavBarTrailingItems
            }
        }
    }
}

extension DetailView {
    private var NavBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25 ,height: 25)
        }
    }
    private var OverviewTitle: some View {
        Text("Details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var DescriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 4)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Hide" : "Read more..")
                            .font(.callout)
                            .fontWeight(.bold)
                            .padding(.vertical, 1)
                    })
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
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
    private var LinksTitle: some View {
        Text("Links")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var LinksBody: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = vm.websiteURL, let url = URL(string: websiteString){
                Link("Website", destination: url)
            }
            if let redditeString = vm.redditURL, let url = URL(string: redditeString){
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}

#Preview {
    NavigationView {
        DetailLoadingView(coin: .constant(DeveloperPreview.instance.coin))
    }
}
