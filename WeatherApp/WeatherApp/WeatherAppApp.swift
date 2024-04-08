//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by João Limiere on 07/04/24.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: WeatherViewModel())
        }
    }
}
