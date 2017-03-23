//
//  HelpedMethods.swift
//  OpenWeatherMapService
//
//  Created by warSong on 3/21/17.
//  Copyright © 2017 VS. All rights reserved.
//

import UIKit

class HelpedMethods {
    static let method = HelpedMethods()
    
    func configureBackgroundImage(iconImage: String) -> UIImage {
        var imageName = String()
        switch iconImage {
        case let name where name == "01d" : imageName = "Sunshine"
        case let name where name == "02d" : imageName = "Sunshine"
        case let name where name == "03d" : imageName = "Clouds"
        case let name where name == "04d" : imageName = "Clouds"
        case let name where name == "09d" : imageName = "Rain-Day"
        case let name where name == "10d" : imageName = "Rain-Day"
        case let name where name == "11d" : imageName = "Rain-Day"
        case let name where name == "09n" : imageName = "Rain-Night"
        case let name where name == "10n" : imageName = "Rain-Night"
        case let name where name == "11n" : imageName = "Rain-Night"
        case let name where name == "01n" : imageName = "Moon-Night"
        case let name where name == "02n" : imageName = "Moon-Night"
        case let name where name == "03n" : imageName = "Moon-Night"
        case let name where name == "04n" : imageName = "Moon-Night"
        case let name where name == "13d" : imageName = "Snow-Day"
        case let name where name == "13n" : imageName = "Snow-Night"
        case let name where name == "50d" : imageName = "Rain-Day"
        case let name where name == "50n" : imageName = "Rain-Night"
        default: imageName = "Sunshine"
        }
        if let iconImage = UIImage(named: imageName) {
        return iconImage
        }else {
        return UIImage(named: "Sunshine")!
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

}
