//
//  Extensions.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 24/11/21.
//

import Foundation
import UIKit

// a "anyswiftdatatype" to string converter
extension LosslessStringConvertible {
    var string: String { .init(self) }
}



extension UIViewController {
    
    // helper to get the hours from a string date and return a simple now appropriatelly
    func stringToDateToHour(dateString: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = dateFormatter.date(from: dateString ?? "") else { return "" }
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())
        if calendar.component(.hour, from: date) == currentHour{
            return "Now"
        }
        let returnHour = calendar.component(.hour, from: date)
        let returnMinute = calendar.component(.minute, from: date)
        
        return  returnMinute > 10 ? "\(returnHour):\(returnMinute)" : "\(returnHour):0\(returnMinute)"
    }
    
// Setting a gradient backgound color
    func setGradientBGColor(current: Current?,bgLayer: CAGradientLayer){
        var bagOfColors = [CGColor]()
        
        if current?.isDay == 0 {
           bagOfColors =  [
              UIColor(red: 0.031, green: 0.084, blue: 0.183, alpha: 1).cgColor,
              UIColor(red: 0.179, green: 0.371, blue: 0.567, alpha: 1).cgColor
            ]
        } else {
            if let weather = current?.condition?.text{
                if weather.lowercased().contains("cloud"){
                    bagOfColors = [
                        UIColor(red: 0.126, green: 0.222, blue: 0.292, alpha: 1).cgColor,
                        UIColor(red: 0.62, green: 0.799, blue: 0.855, alpha: 1).cgColor
                    ]
                }
                else if weather.lowercased().contains("sunny"){
                    bagOfColors = [
                        UIColor(red: 0, green: 0.649, blue: 0.938, alpha: 1).cgColor,
                        UIColor(red: 0.506, green: 0.866, blue: 0.979, alpha: 1).cgColor
                    ]
                }else if weather.lowercased().contains("storm"){
                    bagOfColors = [
                        UIColor(red: 0.158, green: 0.119, blue: 0.287, alpha: 1).cgColor,
                        UIColor(red: 0.794, green: 0.75, blue: 0.938, alpha: 1).cgColor
                    ]
                }else {
                    bagOfColors = [
                        UIColor(red: 0.765, green: 0.814, blue: 0.863, alpha: 1).cgColor,
                        UIColor(red: 0.313, green: 0.35, blue: 0.387, alpha: 1).cgColor
                    ]
                }
            }
        }
        
        bgLayer.colors = bagOfColors
        bgLayer.frame = view.bounds
//        layer.shouldRasterize = true
        view.layer.insertSublayer(bgLayer, at: 0)
    }
    
//  helper to get the icon code and match it to our assets lib
    func getCodeFromImageUrl(imageUrl: String?) -> String{
        let imageString = imageUrl?.replacingOccurrences(of: "//", with: "")
        let imageUrl = URL(string: (imageString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        return imageUrl?.lastPathComponent.replacingOccurrences(of: ".png", with: "") ?? "113"
    }
}


// get the reuseIdentifier automatically

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}



