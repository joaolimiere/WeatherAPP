//
//  Weather.swift
//  WeatherApp
//
//  Created by João Limiere on 07/04/24.
//

struct Weather: Decodable {
    let main: MainInformation
    let weather: [WeatherDescription]

    struct MainInformation: Decodable {
        let temp: Double
        
    }

    struct WeatherDescription: Decodable {
        let main: String
        let description: String
        let icon: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        main = try container.decode(MainInformation.self, forKey: .main)
        weather = try container.decode([WeatherDescription].self, forKey: .weather)
    }

    private enum CodingKeys: String, CodingKey {
        case main, weather
    }
}
