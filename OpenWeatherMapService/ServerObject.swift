//
//  ServerObject.swift
//  OpenWeatherMapService
//
//  Created by warSong on 1/11/17.
//  Copyright © 2017 VS. All rights reserved.
//

import UIKit
import SwiftyJSON


class ServerObject: NSObject {
    var response: JSON
    
    init(response:JSON) {
        self.response = response
    }
    
    
//MARK: -Helped Methods
    func setFormatedCurrentTime(unixTime:Int,dateFormat:String) -> String {
        
        var currentTime:String? = nil
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        if unixTime != 0 {
            let date = Date.init(timeIntervalSince1970: TimeInterval(unixTime))
            let timeDate = formatter.string(from: date)
            currentTime = timeDate
        }
        return currentTime!
    }
    func isSunsetOrSunRise(sunrise:Double,sunset:Double) -> Bool {
        
        let nigthTime:Bool = false
        let currentTime = Date().timeIntervalSince1970
        if (currentTime > sunrise || currentTime < sunset) {
           return nigthTime == true
        }else {
           return nigthTime == false
        }
    }
    func isTimeNightIcon(icon:String) -> Bool {
        if icon.range(of: "n") != nil {
            return false
        }else {
            return true
        }
    }
    
    func currentWeatherIconByID(condition:Int,nightTime:Bool) -> UIImage {
        var imagedName = String()
        
        switch (condition,nightTime)
        {
        //clear sky
        case let (x,y) where x == 800 && y == true: imagedName = "01n"
        case let (x,y) where x == 800 && y == false: imagedName = "01d"
        //few clouds
        case let (x,y) where x == 801 && y == true: imagedName = "02n"
        case let (x,y) where x == 801 && y == false: imagedName = "02d"
        //scattered clouds
        case let (x,y) where x == 802 && y == true: imagedName = "03n"
        case let (x,y) where x == 802 && y == false: imagedName = "03d"
        //broken clouds
        case let (x,y) where x == 803 && y == true: imagedName = "03d"
        case let (x,y) where x == 803 && y == false: imagedName = "04d"
        //overcast clouds
        case let (x,y) where x == 804 && y == true: imagedName = "04n"
        case let (x,y) where x == 804 && y == false: imagedName = "04d"
        //freeze rain
        case let (x,y) where x == 511 && y == true: imagedName = "13n"
        case let (x,y) where x == 511 && y == false: imagedName = "13d"
        //atmosphere
        case let (x,y) where (x <= 781 && x >= 701) && y == true: imagedName = "50n"
        case let (x,y) where (x <= 781 && x >= 701) && y == false: imagedName = "50d"
        //snow
        case let (x,y) where (x <= 622 && x >= 600) && y == true: imagedName = "13n"
        case let (x,y) where (x <= 622 && x >= 600) && y == false: imagedName = "13d"
        //rain
        case let (x,y) where (x <= 531 && x >= 520) && y == true: imagedName = "09n"
        case let (x,y) where (x <= 531 && x >= 520) && y == false: imagedName = "09d"
            
        case let (x,y) where (x <= 504 && x >= 500) && y == true: imagedName = "10n"
        case let (x,y) where (x <= 504 && x >= 500) && y == false: imagedName = "10d"
        //drizzle
        case let (x,y) where (x <= 321 && x >= 300) && y == true: imagedName = "09n"
        case let (x,y) where (x <= 321 && x >= 300) && y == false: imagedName = "09d"
        //thunderstorm
        case let (x,y) where (x <= 232 && x >= 200) && y == true: imagedName = "11n"
        case let (x,y) where (x <= 232 && x >= 200) && y == false: imagedName = "11d"
            
        default:imagedName = "question"
        }
        let iconImage = UIImage(named:imagedName)
        return iconImage!
    }
       func convertToFahrenheitOrCelWith(countryName:String,temperature:Double) -> Double {
        if (countryName == "US") {
            // F
            return round(((temperature - 273.15) * 1.8) + 32)
        }else {
            // C
            return round(temperature - 273.15)
        }
    }
}
