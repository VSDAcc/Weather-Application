//
//  ForecastWeatherModel.swift
//  OpenWeatherMapService
//
//  Created by warSong on 1/14/17.
//  Copyright © 2017 VS. All rights reserved.
//

import UIKit

class ForecastWeatherModel: WeatherModel {
    
    
    override func setAllWeatherProperties() {
        if let countryName = self.response["city"]["country"].string {
            self.country = countryName
        }
        if let cityName = self.response["city"]["name"].string {
            self.cityName = cityName
        }
        for index in 1...4 {
        if let tempResult = self.response["list"][index]["main"]["temp"].double {
            self.temperature = convertToFahrenheitOrCelWith(countryName: self.country, temperature: tempResult)
            self.temperatureArray.append(self.temperature as AnyObject)
        }
        if let weatherID = self.response["list"][index]["weather"][0]["description"].string {
            self.weatherDescription = weatherID
        }
        if let currentIconID = self.response["list"][index]["weather"][0]["id"].int {
        if let weatherIcon = self.response["list"][index]["weather"][0]["icon"].string {
            self.iconID = currentIconID
            let isNightOrDay = isTimeNightIcon(icon: weatherIcon)
            self.icon = currentWeatherIconByID(condition:self.iconID, nightTime: isNightOrDay)
            self.iconArray.append(self.icon as AnyObject)
        }
    }
        if let windSpeed = self.response["list"][index]["wind"]["speed"].double {
            self.windSpeed = windSpeed
        }
        if let humidity = self.response["list"][index]["main"]["humidity"].int {
            self.humidity = humidity
        }
        if let currentTime = self.response["list"][index]["dt"].int {
            self.currentTime = setFormatedCurrentTime(unixTime:currentTime,dateFormat:"HH:mm")
            self.timeArray.append(self.currentTime as AnyObject)
            }
        }
    }
}





