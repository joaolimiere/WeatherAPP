//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by João Limiere on 07/04/24.
//

import XCTest
@testable import WeatherApp

class ContentViewTests: XCTestCase {
    func test_initialState_cityNameIsEmpty() {
        let view = ContentView(viewModel: MockWeatherViewModel())
        XCTAssertEqual(view.viewModel.cityName, "São José do Rio Preto")
    }
    
    func test_initialState_weatherIsNil() {
        let view = ContentView(viewModel: MockWeatherViewModel())
        XCTAssertNil(view.viewModel.weather)
    }
    
    func test_initialState_isLoadingIsFalse() {
        let view = ContentView(viewModel: MockWeatherViewModel())
        XCTAssertFalse(view.viewModel.isLoading)
    }
    
    func test_initialState_errorIsNil() {
        let view = ContentView(viewModel: MockWeatherViewModel())
        XCTAssertNil(view.viewModel.error)
    }
    
    func test_initialState_isCelsiusIsTrue() {
        let view = ContentView(viewModel: MockWeatherViewModel())
        XCTAssertTrue(view.viewModel.isCelsius)
    }
}

class MockWeatherViewModel: WeatherViewModel {
  var fetchWeatherCalled = false

  override func fetchWeather() {
    fetchWeatherCalled = true
  }
}
