//
//  MyPlantsAppApp.swift
//  MyPlantsApp
//
//  Created by Ghaida on 09/11/2026.
//

import SwiftUI

@main
struct MyPlantsAppApp: App {
    @State private var viewModel = PlantViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
