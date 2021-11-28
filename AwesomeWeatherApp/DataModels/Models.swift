//
//  Models.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 20/11/21.
//

import Foundation
import CoreData


// MARK: - Generic ApiResponse wrapper struct
struct ApiResponse: Codable {
    var location: Location
    var current: Current?
    var astronomy: Astronomy?
    var forecast: Forecast?
}

//class ApiResponse2: Codable {
//    var location: Location
//    var current: Current?
//    var astronomy: Astronomy?
//    var forecast: Forecast?
//
//    init(location: Location, current: Current?, astronomy: Astronomy?, forecast: Forecast){
//        self.location = location
//        self.current = current
//        self.astronomy = astronomy
//        self.forecast = forecast
//    }
//}



// This will be present in every request
// MARK: - Location
struct Location: Codable,Hashable {
    var name, region, country: String?
    var lat, lon: Double?
    var tzID: String?
    var localtimeEpoch: Int?
    var localtime: String?

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

//class Location2: NSManagedObject, Codable{//}, Hashable {
//
//
////    static func == (lhs: Location2, rhs: Location2) -> Bool {
////        return lhs.name == rhs.name && lhs.lat == rhs.lat && lhs.lon == rhs.lon
////    }
////
////    func hash(into hasher: inout Hasher) {
////        hasher.combine(name)
////        hasher.combine(lat)
////        hasher.combine(lon)
////    }
//
//
//    var name, region, country: String?
//    var lat, lon: Double?
//    var tzID: String?
//    var localtimeEpoch: Int?
//    var localtime: String?
//
//    enum CodingKeys: String, CodingKey {
//        case name, region, country, lat, lon
//        case tzID = "tz_id"
//        case localtimeEpoch = "localtime_epoch"
//        case localtime
//    }
//
//    init(name: String, region: String, country: String, lat: Double, lon: Double, tzID: String, localtimeEpoch: Int, localtime: String) {
//            self.name = name
//            self.region = region
//            self.country = country
//            self.lat = lat
//            self.lon = lon
//            self.tzID = tzID
//            self.localtimeEpoch = localtimeEpoch
//    }
//}



// MARK: - Current
struct Current: Codable {
    var lastUpdatedEpoch: Int
    var lastUpdated: String
    var tempC, tempF: Double?
    var isDay: Int
    var condition: Condition?
    var windMph: Double?
    var windKph, windDegree: Float
    var windDir: String?
    var pressureMB: Float?
    var pressureIn: Double?
    var precipMm, precipIn, humidity: Float?
    var cloud: Int
    var feelslikeC, feelslikeF: Double?
    var visKM, visMiles, uv: Float?
    var gustMph, gustKph: Double?
//  This doesnt need to be declared a new struct for now. We can present the data in key/value basis without further explanation
    var airQuality: [String: Double]?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case uv
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
        case airQuality = "air_quality"
    }
}


// MARK: - Condition
struct Condition: Codable,Hashable {
    var text, icon: String?
    var code: Int?
}


// MARK: - Forecast
struct Forecast: Codable,Hashable {
    var forecastday: [Forecastday]?
}

// MARK: - Forecastday
struct Forecastday: Codable,Hashable {
    var date: String?
    var dateEpoch: Int?
    var day: Day?
    var astro: Astro?
    var hour: [Hour]?

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, astro, hour
    }
}
// MARK: - Day
struct Day: Codable,Hashable {
    var maxtempC, maxtempF, mintempC, mintempF: Double?
    var avgtempC, avgtempF, maxwindMph, maxwindKph: Double?
    var totalprecipMm, totalprecipIn, avgvisKM, avgvisMiles: Double?
    var avghumidity, dailyWillItRain, dailyChanceOfRain, dailyWillItSnow: Double?
    var dailyChanceOfSnow: Int?
    var condition: Condition?
    var uv: Int?

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case totalprecipIn = "totalprecip_in"
        case avgvisKM = "avgvis_km"
        case avgvisMiles = "avgvis_miles"
        case avghumidity
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case condition, uv
    }
}

// MARK: - Hour
struct Hour: Codable,Hashable {
    
    var timeEpoch: Int?
    var time: String?
    var tempC, tempF: Double?
    var isDay: Int?
    var condition: Condition?
    var windMph, windKph: Double?
    var windDegree: Double?
    var windDir: String?
    var pressureMB: Double?
    var pressureIn: Double?
    var precipMm, precipIn, humidity: Float?
    var cloud: Int?
    var feelslikeC, feelslikeF, windchillC, windchillF: Double?
    var heatindexC, heatindexF, dewpointC, dewpointF: Double?
    var willItRain, chanceOfRain, willItSnow, chanceOfSnow: Float?
    var visKM, visMiles: Double?
    var gustMph, gustKph: Double?
    var uv: Float?

    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case willItRain = "will_it_rain"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case chanceOfSnow = "chance_of_snow"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
        case uv
    }
}

//MARK: - Astronomy

struct Astronomy: Codable,Hashable {
    var astro: Astro?
}

struct Astro: Codable,Hashable {
    var sunrise, sunset, moonrise, moonset: String?
    var moonPhase, moonIllumination: String?

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case moonIllumination = "moon_illumination"
    }
}






