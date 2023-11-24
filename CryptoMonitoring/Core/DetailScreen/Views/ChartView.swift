import SwiftUI

struct ChartView: View {

    @State private var percentageTrimAnimation: CGFloat = 0
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let midY: Double
    private let lineColor: Color
    private let endDate: Date
    private let startDate: Date

    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        self.midY = (maxY + minY) / 2

        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        self.lineColor = (priceChange > 0) ? Color.theme.green : Color.theme.red

        self.endDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        self.startDate = endDate.addingTimeInterval(-7*24*60*60)
    }

    var body: some View {
        VStack {
            GeometryView
                .frame(height: 200)
                .background(GeometryBackground)
                .overlay(GeometryYAxis.padding(.horizontal, 4), alignment: .leading)
                .font(.caption2)
            GeometryDateLabel
                .padding(.horizontal, 4)
                .font(.caption)
        }
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 1.5)) {
                    percentageTrimAnimation = 1.0
                }
            }
        }
    }
}

extension ChartView {
    private var GeometryView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {

                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: 0, y: 0))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))

                }
            }
            .trim(from: 0, to: percentageTrimAnimation)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor,radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5),radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2),radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1),radius: 10, x: 0, y: 50)
        }
    }
    private var GeometryBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    private var GeometryYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(midY.formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    private var GeometryDateLabel: some View {
        HStack {
            Text(startDate.asShortDateString())
            Spacer()
            Text(endDate.asShortDateString())
        }
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}
