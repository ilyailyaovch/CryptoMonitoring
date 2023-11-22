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
        }.sheet(isPresented: $showPortfolioView, content: { PortfolioView().environmentObject(vm) })
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
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = (vm.sortOption == .rank) ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = (vm.sortOption == .holdings) ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5,alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = (vm.sortOption == .price) ? .priceReversed : .price
                }
            }
            RefreshButton
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    private var RefreshButton: some View {
        Button(action: {
            withAnimation(.linear(duration: 1.5)) {
                vm.updateCoinsData()
            }
        },label: {
            Image(systemName: "goforward")
        }).rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
    }
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
        .refreshable { vm.updateCoinsData() }
    }
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
        .refreshable { vm.updateCoinsData() }
    }
}

#Preview {
    NavigationView {
        HomeView().toolbar(.hidden)
    }.environmentObject(DeveloperPreview.instance.homeVM)
}
