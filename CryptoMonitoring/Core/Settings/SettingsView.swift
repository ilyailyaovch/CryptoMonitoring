import SwiftUI

struct SettingsView: View {

    private let defaultURL = URL(string: "https://www.google.com")!
    private let githubURL = URL(string: "https://github.com/ilyailyaovch/CryptoMonitoring")!
    private let coingeckoURL = URL(string: "https://www.coingecko.com")!


    var body: some View {
        NavigationView {
            List{
                AboutApp
                Coingecko
                Application
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

extension SettingsView {
    private var AboutApp: some View {
        Section(header: Text("About this app")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by Ilia Ovchinnikov.\nStack: MVVM, Combine, CoreData")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }.padding(.vertical)
            Link("Check this project on github", destination: githubURL)
        }
    }
    private var Coingecko: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency datathat is used in thid app comes from a free API from CoinGecko!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }.padding(.vertical)
            Link("Visit CoinGecko", destination: coingeckoURL)
        }
    }
    private var Application: some View {
        Section(header: Text("Application")) {
            Link("Terms of Service", destination: defaultURL)
            Link("Private Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }
    }
}

#Preview {
    SettingsView()
}
