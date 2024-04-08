//
//  ContentView.swift
//  WeatherApp
//
//  Created by João Limiere on 07/04/24.
//

import SDWebImage
import SDWebImageSwiftUI
import SwiftUI

struct ContentView: View {
    @StateObject internal var viewModel: WeatherViewModel

    // Initialize viewModel within the initializer itself
    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                TemperatureSwitchView(isCelsius: $viewModel.isCelsius)
                    .padding(.leading) // Add leading padding for spacing

                TextField("Enter city name", text: $viewModel.cityName)
                          .padding()
                          .border(Color.gray, width: 1)

                Button("Get Weather") {
                    viewModel.fetchWeather()
                }
                .disabled(viewModel.cityName.isEmpty)
                .padding()

                HStack(alignment: .center) {
                    WeatherIconView(iconName: $viewModel.icon)
                        .padding(.trailing)

                    if let weather = viewModel.weather {
                        WeatherView(weather: weather, isCelsius: viewModel.isCelsius)
                            .padding()
                    } else {
                        VStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .frame(width: 50, height: 50)
                            } else if let error = viewModel.error {
                                Text(error)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }

                Button("Refresh") {
                    viewModel.refresh()
                }
                .padding()
            }
            .navigationTitle("Weather App")
        }
    }
}

#Preview {
    ContentView(viewModel: WeatherViewModel())
}
