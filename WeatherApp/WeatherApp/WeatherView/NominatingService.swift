//
//  NominatingService.swift
//  WeatherApp
//
//  Created by João Limiere on 07/04/24.
//

import Foundation
class NominatimService {
  static func searchLocation(searchText: String, completion: @escaping (Result<[City], Error>) -> Void) {
    guard !searchText.isEmpty else { return }

    let urlString = "https://nominatim.openstreetmap.org/search?q=\(searchText)&format=json&limit=5"

    guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
      completion(.failure(NSError(domain: "Nominatim", code: 1, userInfo: ["message": "Invalid URL"])))
      return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }

      guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(NSError(domain: "Nominatim", code: 2, userInfo: ["message": "Failed to fetch data"])))
        return
      }

      do {
          let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]

            // Extract and return only cities with "addresstype": "municipality"
            let cities = json?.compactMap { location -> City? in
              guard let cityName = location["name"] as? String,
                    let addressType = location["addresstype"] as? String,
                    addressType == "municipality" else { return nil }

              // Create a City model based on the data
              return City(name: cityName)
            }


          completion(.success(cities ?? []))
      } catch {
        completion(.failure(error))
      }
    }.resume()
  }
}
struct City: Decodable {
  let name: String
}
