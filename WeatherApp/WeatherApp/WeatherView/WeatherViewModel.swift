//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by João Limiere on 07/04/24.
//
import Combine
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var temperature: String = ""
    @Published var icon: String = "01d"
    @Published var weather: Weather? = nil
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    @Published var isCelsius = true
    @Published var suggestions: [String] = []

    private let weatherService: WeatherService
    private var disposables = Set<AnyCancellable>()
    private var lastCityName = ""

    init(weatherService: OpenWeatherMapService = OpenWeatherMapService()) {
        self.weatherService = weatherService

        $cityName
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .flatMap { [weak self] city -> AnyPublisher<Weather, Never> in
                guard let self = self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                
                if city.isEmpty { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.weatherService.fetchWeather(forCity: city, isCelsius: self.isCelsius)
                    .catch { error -> AnyPublisher<Weather, Never> in
                        self.error = error.localizedDescription
                        return Empty(completeImmediately: true).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
            }, receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .sink(receiveValue: { [weak self] item in
                guard let self = self else {
                    return
                }
                self.weather = item
                self.temperature = "\(item.main.temp)°\(self.isCelsius ? "C" : "F")"
                if let weather = item.weather.first {
                    self.icon = weather.icon
                }
            })
            .store(in: &disposables)
    }

    func refresh() {
        if !cityName.isEmpty {
            fetchWeather()
        }
    }

    func fetchWeather() {
        getObjectFromLatLon { [weak self] _, _ in
            guard let self = self else { return }
            self.weatherService.fetchWeather(forCity: cityName, isCelsius: self.isCelsius)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.error = error.localizedDescription
                    }
                }, receiveValue: { item in
                    self.weather = item
                    self.temperature = "\(item.main.temp)°\(self.isCelsius ? "C" : "F")"
                    if let weather = item.weather.first {
                        self.icon = weather.icon
                    }
                })
                .store(in: &self.disposables)
        }
    }

    func convertToFahrenheit(temp: Double) -> Double {
        return (temp * 9 / 5) + 32
    }

    private func getObjectFromLatLon(completion: @escaping (Double, Double) -> Void) {
        // Implement CoreLocation logic to get user's location and call completion with lat & lon
        // Replace with your implementation using CoreLocation framework
        completion(0.0, 0.0) // Placeholder values, replace with actual coordinates
    }
}

// MARK: Search City

extension WeatherViewModel {
    func searchLocation() {
        guard !cityName.isEmpty, cityName != lastCityName else { return }
        lastCityName = cityName

        isLoading = true
        error = nil

        NominatimService.searchLocation(searchText: cityName) { result in
            self.isLoading = false

            switch result {
            case let .success(cities):
                self.suggestions = cities.map { $0.name }
            case let .failure(error):
                self.error = error.localizedDescription
            }
        }
    }
}
