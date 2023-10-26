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

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView().toolbar(.hidden)
            }.environmentObject(vm)
        }
    }
}
