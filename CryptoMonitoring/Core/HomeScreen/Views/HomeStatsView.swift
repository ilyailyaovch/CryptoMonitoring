import SwiftUI

struct HomeStatsView: View {

    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    private let customWidth = UIScreen.main.bounds.width

    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: customWidth / 3)
            }
        }
        .frame(width: customWidth, alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreview.instance.homeVM)
}
