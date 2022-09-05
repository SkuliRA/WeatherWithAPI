//
//  CurrentWeather.swift
//  Sunny
//
//  Created by Skuli on 03.09.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    let feelsLike: Double
    var feelsLikeString: String {
        return String(format: "%.0f", feelsLike)
    }
    
    let conditionCode: Int
    var iconName: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "cloud.fog.fill"
        case 800: return "sun.max"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    // failable инициализатор, который может вернуть nil
    // если что-то пойдет не по плану инициализатор вернет nil
    init?(currentWeatherData: CurrentWeatherData) {
        self.cityName = currentWeatherData.name
        self.temperature = currentWeatherData.main.temp
        self.feelsLike = currentWeatherData.main.feelsLike
        self.conditionCode = currentWeatherData.weather.first!.id
    }
    
}
