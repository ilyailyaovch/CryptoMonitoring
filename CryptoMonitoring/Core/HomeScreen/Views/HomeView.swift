import SwiftUI

struct HomeView: View {

    @EnvironmentObject var vm: HomeViewModel
    @State private var showPortfolio = false
    @State private var showPortfolioView: Bool = false

    var body: some View {
        ZStack {
            // Background
            Color.theme.background.ignoresSafeArea()
            // Content
            VStack {
                HomeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                ColumnTitles
                switch showPortfolio {
                case false: allCoinsList.transition(.move(edge: .leading))
                case true: portfolioCoinsList.transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }.sheet(isPresented: $showPortfolioView,content: { PortfolioView().environmentObject(vm) })
    }
}

extension HomeView {
    private var HomeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture { if showPortfolio { showPortfolioView.toggle() }}
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture { withAnimation(.spring) { showPortfolio.toggle() }}
        }.padding(.horizontal)
    }
    private var ColumnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationView {
        HomeView().toolbar(.hidden)
    }.environmentObject(DeveloperPreview.instance.homeVM)
}
