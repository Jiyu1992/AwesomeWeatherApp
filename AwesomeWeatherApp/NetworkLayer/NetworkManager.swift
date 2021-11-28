//
//  NetworkManager.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 21/11/21.
//

import Foundation
import UIKit

protocol NetworkManagerProtocol {
    func fetchCurrentWeather(parameter: String, completion: @escaping (Current?, Error?) ->Void)
//  we may need [Forecast]
    func fetchNextFiveWeatherForecast(parameter: String, completion: @escaping (Forecast?, Error?) ->Void)
    func fetchGeneric(parameter: String, typeOfCall: TypeOfCall ,completion: @escaping (ApiResponse?, Error?) ->Void)
}

enum TypeOfCall{
    case current
    case forecast
    case search
}

enum Result<String>{
       case success
       case failure(String)
}

// optional
enum NetworkResponse: String{
    case success = "We did it"
    case authenticationError = "You need to be authorized"
    case badRequest = "Bad Request"
    case outdated = "The url is outdated"
    case failed = "Network request failed"
    case noData = "Data empty"
    case unableToDecode = "Unable to decode the response"
}

fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
    switch response.statusCode {
    case 200...299: return .success
    case 400...500: return .failure(NetworkResponse.authenticationError.rawValue + " \(response.statusCode)")
    case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
    case 600: return .failure(NetworkResponse.outdated.rawValue)
    default: return .failure(NetworkResponse.failed.rawValue)
        
    }
    
}

class NetworkManager: NetworkManagerProtocol {
    
//    let shared = NetworkManager()
    
    func makeApiCall<T: Codable>(with url: URL ,completionHandler: @escaping (_ jsonResponse: T?, _ error: Error?) -> ()) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(UsefullKeys.app_json, forHTTPHeaderField: UsefullKeys.content_type)
        request.addValue(UsefullKeys.app_json, forHTTPHeaderField: UsefullKeys.accept)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) {(data, response, error) -> Void in
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                switch result {
                case .success:
                    do {
                        if let json = try JSONDecoder().decode(T?.self, from: data!) {
                            completionHandler(json, nil)
                        } else {
                            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                            print("\nJSON Response: \(dataString)\n")
                            completionHandler(nil, error)
                        }
                        
                    } catch(let decodingError) {
                        print("\nERROR - INVALID JSON RESPONSE")
                        let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                        print("\nJSON Response: \(dataString)\n")
                        completionHandler(nil, decodingError)
                    }
                case .failure(let apiCallError):
                    print("\nERROR - RESPONSE \(apiCallError)")
                    completionHandler(nil, error)
                    
                }
            }
            else {
                print(error.debugDescription)
                completionHandler(nil, error)
            }
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
    
//  These may not be neede, further testing is required!
    func fetchCurrentWeather(parameter: String, completion: @escaping (Current?, Error?) ->Void) -> () {
        
        guard let url = URL(string: URLs.currentWeather.replacingOccurrences(of: "parameter", with: parameter)) else
        { return }
        return self.makeApiCall(with: url, completionHandler: completion)
    }
    
    func fetchNextFiveWeatherForecast(parameter: String, completion: @escaping (Forecast?, Error?) ->Void) -> () {
        guard let url = URL(string: URLs.currentWeather.replacingOccurrences(of: "parameter", with: parameter)) else
        { return }
        return self.makeApiCall(with: url, completionHandler: completion)
    }
    
    func fetchSearch(parameter: String, completion: @escaping ([Location]?, Error?) ->Void) -> () {
        guard let url = URL(string: URLs.search.replacingOccurrences(of: "parameter", with: parameter).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else
        { return }
        return self.makeApiCall(with: url, completionHandler: completion)
    }

    
//  MARK: - This works as expected. We do not need any specified model-centric methods, Hooray!
    
    func fetchGeneric(parameter: String, typeOfCall: TypeOfCall,completion: @escaping (ApiResponse?, Error?) ->Void) -> () {
        var url: URL!
//      differentiate between the various api calls we need to make
        switch typeOfCall {
        case .current:
            url = URL(string: URLs.currentWeather.replacingOccurrences(of: "parameter", with: parameter).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        case .forecast:
            url = URL(string: URLs.forecast.replacingOccurrences(of: "parameter", with: parameter).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        case .search:
            url = URL(string: URLs.search.replacingOccurrences(of: "parameter", with: parameter).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }
//      guarantee the validity of the url
        guard let validUrl = url else
        { return }
//      call the generic makeApiCall
        return self.makeApiCall(with: validUrl, completionHandler: completion)
    }
}
