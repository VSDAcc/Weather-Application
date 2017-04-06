//
//  ViewController.swift
//  OpenWeatherMapService
//
//  Created by warSong on 1/9/17.
//  Copyright © 2017 VS. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation


class ViewController: UIViewController {
    let forecastCellIdentifire = "ForecastCell"
    var currentCityName = String()
    var hud = MBProgressHUD()
    var locationManager:CLLocationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var currentCoordinate = CLLocationCoordinate2D()
    var cityID: Int!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var forecastArray = [WeatherModel]()
    
    //MARK:-Actions
    @IBAction func actionSearchCountryButton(_ sender: UIBarButtonItem) {
        self.alertDisplayCityName()
    }
    @IBAction func actionGetCurrentLocation(_ sender: UIBarButtonItem) {
        self.getOpenWeatherMapWithCoordinates()
    }
    //MARK:-Loading
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocationManager()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:-LocationManagerDelegate
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: -OpenWeatherMapService
    func alertDisplayCityName() {
        let alert = UIAlertController(title: "City",
                                    message: "Enter city name",
                             preferredStyle: UIAlertControllerStyle.alert)
        let actionCancel = UIAlertAction(title: "Cancel",
                                         style: UIAlertActionStyle.cancel,
                                       handler: nil)
        let actionOk = UIAlertAction(title: "Ok",
                                     style: UIAlertActionStyle.default,
                                   handler: { (action) in
            if let textField = alert.textFields?.first as UITextField! {
                self.activityIndicatorStart()
                ServerManager.sharedManager.getOpenWeatherMapRequestWithCityName(cityName:textField.text!,
                                                    onSuccess: { (weatherObject) in
                                                        self.setupAllViewsFromServerObject(weatherObject: weatherObject)
                                                        let imageName = weatherObject.iconName
                                                        self.configureBackgroundImage(imagedName: imageName!)
                                                        self.getforecastWeatherFromServer(cityID: weatherObject.cityID)
                                                        self.slideWindAndHumitidyLabel()
                                                        self.fadeInAnimationLabels()
                },
                                                    onFailure: {(error) in
                                                        self.alertErrorDescription(erorr: (error?.localizedDescription)!)
                                                        self.hud.hide(animated: true)
                })
            }
        })
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        alert.addTextField { (textField) in
            textField.placeholder = "City name"
        }
        self.present(alert, animated: true, completion: nil)
    }
    func getOpenWeatherMapWithCoordinates()  {
        ServerManager.sharedManager.getOpenWeatherMapRequestWithCoordinate(coordinate: self.currentCoordinate,
                                                                           onSuccess: { (weatherObject) in
                                                                            self.setupAllViewsFromServerObject(weatherObject: weatherObject)
                                                                            let imageName = weatherObject.iconName
                                                                            self.configureBackgroundImage(imagedName: imageName!)
                                                                            self.getforecastWeatherFromServer(cityID: weatherObject.cityID)
                                                                            self.slideWindAndHumitidyLabel()
                                                                            self.fadeInAnimationLabels()
        },
                                                                           onFailure: {(error) in
                                                                            self.alertErrorDescription(erorr: (error?.localizedDescription)!)
                                                                            self.hud.hide(animated: true)
        })
    }
    func getforecastWeatherFromServer(cityID: Int) {
        ServerManager.sharedManager.getOpenWeatherMapRequestForecastWithCityID(cityID:cityID,
                                                                               onSuccess: { (weatherObject) in
                                                                                var tempArray = [WeatherModel]()
                                                                                for _ in 0...10 {
                                                                                    tempArray.append(weatherObject)
                                                                                }
                                                                                self.forecastArray = tempArray
                                                                                self.collectionView.reloadData()
        }, onFailure: {(error) in
            self.alertErrorDescription(erorr: (error?.localizedDescription)!)
        })
    }
    //MARK:-SetupViews
    func setupAllViewsFromServerObject(weatherObject: WeatherModel) {
        self.cityNameLabel.text = "\(weatherObject.cityName),\(weatherObject.country)"
        self.currentTimeLabel.text = weatherObject.currentTime
        self.temperatureLabel.text = "\(String(weatherObject.temperature))°"
        self.windSpeedLabel.text = String(weatherObject.windSpeed)
        self.humidityLabel.text = String(weatherObject.humidity)
        self.descriptionLabel.text = weatherObject.weatherDescription
        self.cityID = weatherObject.cityID
        if weatherObject.icon != nil {
            DispatchQueue.main.async(execute: {
                self.iconImageView.image = weatherObject.icon
                self.hud.hide(animated: true)
            })
        }
    }
    //MARK:-HelpedMethods
    func configureBackgroundImage(imagedName: String) {
        let image = HelpedMethods.method.configureBackgroundImage(iconImage: imagedName)
        self.backgroundImage.image = image
        self.view.backgroundColor = UIColor(patternImage: self.backgroundImage.image!)
    }
    func alertErrorDescription(erorr:String) {
        let alert = UIAlertController(title: "Error",
                                      message:erorr,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let actionCancel = UIAlertAction(title: "Ok",
                                         style: UIAlertActionStyle.cancel,
                                         handler: nil)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func activityIndicatorStart()  {
        self.hud.label.text = "Loading..."
        self.view.addSubview(hud)
        self.hud.show(animated: true)
    }
    func slideWindAndHumitidyLabel() {
        self.windSpeedLabel.transform = CGAffineTransform(translationX: -150, y: 0).scaledBy(x: 2, y: 2)
        self.humidityLabel.transform = CGAffineTransform(translationX: 150, y: 0).scaledBy(x: 2, y: 2)
        
        UIView.animate(withDuration: 0.7, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.windSpeedLabel.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1, y: 1)
            self.humidityLabel.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1, y: 1)
        }, completion: { (finished) in
        })
    }
    func fadeInAnimationLabels() {
        self.temperatureView.alpha = 0
        self.descriptionLabel.alpha = 0
        self.currentTimeLabel.alpha = 0
        self.cityNameLabel.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.temperatureView.alpha = 1
            self.descriptionLabel.alpha = 1
            self.currentTimeLabel.alpha = 1
            self.cityNameLabel.alpha = 1
        })
    }
}
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.7, animations: {
            cell.alpha = 1.0
        })
    }
}
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecastArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: forecastCellIdentifire, for: indexPath) as! ForecastCollectionViewCell
        let weatherModel = self.forecastArray[indexPath.item]
        let icon = weatherModel.iconArray[indexPath.item]
        let temp = weatherModel.temperatureArray[indexPath.item]
        let time = weatherModel.timeArray[indexPath.item]
        DispatchQueue.main.async {
            cell.temperatureLabel.text = "\(String(describing: temp))°"
            cell.weatherImageView.image = icon as? UIImage
            cell.timeLabel.text = time as? String
        }
        return cell
    }
}
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation:CLLocation = locations.last!
        if (currentLocation.horizontalAccuracy > 0) {
            locationManager.stopUpdatingLocation()
            let coordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            self.currentLocation = currentLocation
            self.currentCoordinate = coordinate
            self.activityIndicatorStart()
            self.getOpenWeatherMapWithCoordinates()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

