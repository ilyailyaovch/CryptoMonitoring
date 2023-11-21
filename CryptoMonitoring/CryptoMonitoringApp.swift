//
//  CryptoMonitoringApp.swift
//  CryptoMonitoring
//
//  Created by Ilya Ovchinnikov on 25.10.2023.
//

import SwiftUI

@main
struct CryptoMonitoringApp: App {

    @StateObject private var vm = HomeViewModel()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView().toolbar(.hidden)
            }.environmentObject(vm)
        }
    }
}
