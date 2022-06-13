//
//  DessertStuffApp.swift
//  DessertStuff
//
//  Created by Chan Jung on 6/13/22.
//

import SwiftUI

@main
struct DessertStuffApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
                .navigationTitle("Desserts")
        }
    }
}
