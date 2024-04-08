//
//  CitySuggestion.swift
//  WeatherApp
//
//  Created by João Limiere on 07/04/24.
//

import Foundation

struct CitySuggestions: Decodable {
  let stations: [Station]
  
  struct Station: Decodable {
    let name: String
  }
}
