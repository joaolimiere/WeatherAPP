//
//  TemperatureSwitchView.swift
//  WeatherApp
//
//  Created by João Limiere on 07/04/24.
//

import SwiftUI

struct TemperatureSwitchView: View {
  @Binding var isCelsius: Bool // Estado para acompanhar a unidade selecionada

  var body: some View {
    HStack {
      Text("°C")
        .foregroundColor(isCelsius ? .blue : .gray)
        .onTapGesture {
          self.isCelsius = true
        }
      
      Spacer(minLength: 0) // Force space to fill remaining space

      Text("°F")
        .foregroundColor(isCelsius ? .gray : .blue)
        .onTapGesture {
          self.isCelsius = false
        }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(10)
    .frame(maxWidth: 100) // Set minimum width for the view
  }
}
