//
//  Constants.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 20/11/21.
//

import Foundation

enum URLs {
    static let baseURL = "https://api.weatherapi.com/v1"
    static let json = ".json"
    static let currentWeather = baseURL + "/current" + json + UsefullKeys.apiKey + UsefullKeys.parameter
    
    static let forecast = baseURL + "/forecast" + json + UsefullKeys.apiKey + UsefullKeys.parameter + "&days=3" + "&alerts=no"
    static let search = baseURL + "/search" + json + UsefullKeys.apiKey + UsefullKeys.parameter
//    only in pro
//    static let history = baseURL + "/history" + json + UsefullKeys.apiKey
    static let timeZone = baseURL + "/timeZone" + json + UsefullKeys.apiKey
    static let sports = baseURL + "/sports" + json + UsefullKeys.apiKey
    static let astronomy = baseURL + "/astronomy" + json + UsefullKeys.apiKey
    static let ipLookUp = baseURL + "/ip" + json + UsefullKeys.apiKey
}

enum UsefullKeys {
    static let apiKey = "?key=213821a934d04a3ebb5200408212111&"
    static let parameter = "q=parameter&aqi=yes"
    static let app_json = "application/json; charset=utf-8"
    static let content_type = "Content-Type"
    static let accept = "Accept"
}
