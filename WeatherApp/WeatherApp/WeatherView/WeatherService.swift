//
//  WeatherService.swift
//  WeatherApp
//
//  Created by João Limiere on 07/04/24.
//

import Combine
import Foundation

protocol WeatherService {
    func fetchWeather(forCity: String, isCelsius: Bool) -> AnyPublisher<Weather, Error>
    func fetchWeather(byLatLon lat: Double, lon: Double, isCelsius: Bool) -> AnyPublisher<Weather, Error>
}

class OpenWeatherMapService: WeatherService {
    private let apiKey: String = {
      guard let key = ProcessInfo.processInfo.environment["OpenWeatherMapAPIKey"] else {
        fatalError("Missing OpenWeatherMap API Key! Set the 'OpenWeatherMapAPIKey' environment variable in your Xcode scheme.")
      }
      return key
    }()
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(forCity: String, isCelsius: Bool) -> AnyPublisher<Weather, Error> {
        guard let url = url(forCity: forCity) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Weather.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchWeather(byLatLon lat: Double, lon: Double, isCelsius: Bool) -> AnyPublisher<Weather, Error> {
        guard let url = url(latitude: lat, longitude: lon) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Weather.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchCitySuggestions(searchText: String) -> AnyPublisher<CitySuggestions, Error> {
        guard !searchText.isEmpty else { return Empty().eraseToAnyPublisher() }

        guard let url = url(forCity: searchText) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CitySuggestions.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    // Helper function for constructing URLs safely
    private func url(latitude: Double, longitude: Double) -> URL? {
        return URL(string: "\(baseUrl)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric")
    }

    private func url(forCity: String) -> URL? {
        return URL(string: "\(baseUrl)?q=\(forCity)&appid=\(apiKey)&units=metric")
    }
}
