//
//  WeatherView.swift
//  WeatherApp
//
//  Created by João Limiere on 07/04/24.
//

import SwiftUI
struct WeatherView: View {
    let weather: Weather
    let isCelsius: Bool

    var body: some View {
        VStack(alignment: .center) {
            Text(weather.weather.first?.main ?? "-")
                .font(.title)
            Text(weather.weather.first?.description ?? "-")
            
            Text(formatTemperature(temp: weather.main.temp, isCelsius: isCelsius))
                .font(.title2)
        }
    }

    private func formatTemperature(temp: Double, isCelsius: Bool) -> String {
        let tempValue = isCelsius ? temp : convertToFahrenheit(temp: temp)
        return String(format: "%.1f°", tempValue)
    }

    func convertToFahrenheit(temp: Double) -> Double {
        return (temp * 9 / 5) + 32
    }
}
