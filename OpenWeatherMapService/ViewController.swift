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


class ViewController: UIViewController,CLLocationManagerDelegate,UIPopoverPresentationControllerDelegate {
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

    @IBAction func actionSearchCountryButton(_ sender: UIBarButtonItem) {
        alertDisplayCityName()
    }
    @IBAction func actionGetCurrentLocation(_ sender: UIBarButtonItem) {
        self.getOpenWeatherMapWithCoordinates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let background = UIImage(named:"background")
        self.view.backgroundColor = UIColor(patternImage: background!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocationManager()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//MARK:-Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPopover" {
            let controller:ForecastViewController = segue.destination as! ForecastViewController
            controller.popoverPresentationController?.delegate = self
            controller.cityID = self.cityID
        }
    }
//MARK:-LocationManagerDelegate
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location ?? "nil")
        let currentLocation:CLLocation = locations.last!
        if (currentLocation.horizontalAccuracy > 0) {
            locationManager.stopUpdatingLocation()
            let coordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            self.currentLocation = currentLocation
            self.currentCoordinate = coordinate
            self.activityIndicator()
            self.getOpenWeatherMapWithCoordinates()
     }
}
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
//MARK: -Helped Methods
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
                self.activityIndicator()
                ServerManager.sharedManager.getOpenWeatherMapRequestWithCityName(cityName:textField.text!,
                                                    onSuccess: { (weatherObject) in
                                                        self.cityNameLabel.text = "\(weatherObject.cityName),\(weatherObject.country)"
                                                        self.currentTimeLabel.text = weatherObject.currentTime
                                                        self.temperatureLabel.text = "\(String(weatherObject.temperature))°"
                                                        self.windSpeedLabel.text = String(weatherObject.windSpeed)
                                                        self.humidityLabel.text = String(weatherObject.humidity)
                                                        self.descriptionLabel.text = weatherObject.weatherDescription
                                                        self.cityID = weatherObject.cityID
                                                        
                                                        self.slideWindAndHumitidyLabel()
                                                        self.fadeInAnimationLabels()
                                                        if weatherObject.icon != nil {
                                                            DispatchQueue.main.async(execute: {
                                                                self.iconImageView.image = weatherObject.icon
                                                                self.hud.hide(animated: true)
                                                            })
                                                        }
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
                                                self.cityNameLabel.text = "\(weatherObject.cityName),\(weatherObject.country)"
                                                self.currentTimeLabel.text = weatherObject.currentTime
                                                self.temperatureLabel.text = "\(String(weatherObject.temperature))°"
                                                self.windSpeedLabel.text = String(weatherObject.windSpeed)
                                                self.humidityLabel.text = String(weatherObject.humidity)
                                                self.descriptionLabel.text = weatherObject.weatherDescription
                                                self.cityID = weatherObject.cityID
                                                
                                                self.slideWindAndHumitidyLabel()
                                                self.fadeInAnimationLabels()
                                                if self.iconImageView != nil {
                                                    DispatchQueue.main.async(execute: {
                                                        self.iconImageView.image = weatherObject.icon
                                                        self.hud.hide(animated: true)
                                                    })
                                                }
        },
                                               onFailure: {(error) in
                                                self.alertErrorDescription(erorr: (error?.localizedDescription)!)
                                                self.hud.hide(animated: true)
        })
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
    
    func activityIndicator()  {
        self.hud.label.text = "Loading..."
        self.view.addSubview(hud)
        self.hud.show(animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
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
    func makeBlurEffectToView(view:UIView, effectStule:UIBlurEffectStyle) {
        view.backgroundColor = UIColor.clear
        let blurEffect:UIBlurEffect = UIBlurEffect(style: effectStule)
        let visualEffectView:UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        view.insertSubview(visualEffectView, at: 0)
    }
}

