//
//  ServerManager.swift
//  OpenWeatherMapService
//
//  Created by warSong on 1/10/17.
//  Copyright © 2017 VS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

var stringURL: String = "http://api.openweathermap.org/data/2.5/weather?"
var stringForecastURL: String = "http://api.openweathermap.org/data/2.5/forecast?"
var appID: String = "37bf77fd2230b3edb5dc9c1b7df083dc"

class ServerManager {
    static let sharedManager = ServerManager()

func getOpenWeatherMapRequestWithCityName (cityName:String,
                                          onSuccess:@escaping(_ weatherObject:WeatherModel) -> (),
                                          onFailure:@escaping(_ error: Error?) -> ()) {
    
    let params = ["q" : cityName,
              "APPID" : appID]
    
    Alamofire.request(stringURL, method: .get,parameters: params)
        .validate()
        .responseJSON { response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            let weatherObject = WeatherModel(response:json)
            weatherObject.setAllWeatherProperties()
            onSuccess(weatherObject)
        case .failure(let error):
            onFailure(error)
        }
    }
}
func getOpenWeatherMapRequestWithCoordinate (coordinate:CLLocationCoordinate2D,
                                              onSuccess:@escaping(_ weatherObject:WeatherModel) -> (),
                                              onFailure:@escaping(_ error: Error?) -> ()) {
    let params = ["lat" : coordinate.latitude,
                  "lon" : coordinate.longitude,
                "APPID" : appID] as [String : Any]
    
    Alamofire.request(stringURL, method: .get,parameters: params)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let weatherObject = WeatherModel(response:json)
                weatherObject.setAllWeatherProperties()
                onSuccess(weatherObject)
            case .failure(let error):
                onFailure(error)
            }
    }
}
func getOpenWeatherMapRequestForecastWithCityID (cityID:Int,
                                              onSuccess:@escaping(_ weatherObject:WeatherModel) -> (),
                                              onFailure:@escaping(_ error: Error?) -> ()) {
    
    let params = ["id" : cityID,
               "APPID" : appID] as [String : Any]
    
    Alamofire.request(stringForecastURL, method: .get,parameters: params)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let weatherObject = ForecastWeatherModel(response:json)
                weatherObject.setAllWeatherProperties()
                onSuccess(weatherObject)
            case .failure(let error):
                onFailure(error)
            }
    }
}
func getWeatherFromServer(onSuccess:@escaping(_ weatherObject:WeatherModel) -> (),
                          onFailure:@escaping(_ error: Error?) -> ())
{    
    let url: URL = URL.init(string: stringURL)!
    let urlRequest = URLRequest.init(url: url)
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: urlRequest,
                   completionHandler: {
                   (location, response,error) in
                    guard error == nil else {
                        print("error calling GET on /todos/1")
                        print(error ?? "ERROR")
                        return
                    }
                    // make sure we got data
                    guard let responseData = location else {
                        print("Error: did not receive data")
                        return
                    }
                    // parse the result as JSON, since that's what the API provides
                    do {
                        guard let weatherJSON = try JSONSerialization.jsonObject(with:responseData, options:[]) as? JSON
                            else {
                            print("error trying to convert data to JSON")
                            return
                        }
                        print("The weatherJSON is" + weatherJSON.description)
                        let weatherObject = WeatherModel.init(response: weatherJSON)
                        weatherObject.setAllWeatherProperties()
                        onSuccess(weatherObject)
                        guard let weatherJSONTittle = weatherJSON["title"].string else {
                            print("Could not get todo title from JSON")
                            return
                        }
                        print("The title is:" + weatherJSONTittle)
                    } catch  {
                        onFailure(error)
                        print("error trying to convert data to JSON")
                        return
                    }
    })
    task.resume()
   }
}
