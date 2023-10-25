//
//  CryptoMonitoringApp.swift
//  CryptoMonitoring
//
//  Created by Ilya Ovchinnikov on 25.10.2023.
//

import SwiftUI

@main
struct CryptoMonitoringApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView().toolbar(.hidden)
            }
        }
    }
}
