//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Skuli on 31.08.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation
import CoreLocation

enum RequestType {
    case cityName(city: String)
    case coordinate(latitude: CLLocationDegrees, longitiude: CLLocationDegrees)
}

struct NetworkWeatherManager {
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=\(units)"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(units)"
        }
        performRequest(withURLString: urlString)
    }
    
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = parseJSON(data) {
                    if let onCompletion = onCompletion {
                        onCompletion(currentWeather)
                    }
                }
            }
        }
        task.resume()
    }
    
    fileprivate func parseJSON(_ data: Data) -> CurrentWeather? {
        do {
            let currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
