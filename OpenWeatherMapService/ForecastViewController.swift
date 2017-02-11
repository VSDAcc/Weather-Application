//
//  ForecastViewController.swift
//  OpenWeatherMapService
//
//  Created by warSong on 1/14/17.
//  Copyright © 2017 VS. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    var cityID: Int!
    
    @IBOutlet var forecastTimeLabel: [UILabel]!
    @IBOutlet var forecastIconImageView: [UIImageView]!
    @IBOutlet var forecastTemperatureLabel: [UILabel]!
    @IBOutlet var forecastView: UIView!
    var force: CGFloat!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        self.makeBlurEffectToView(view: forecastView, effectStule: UIBlurEffectStyle.light)
        self.forecastView.isOpaque = false
        force = 5
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
        
        forecastView.layer.add(self.shakeAnimation(keyPath: "position.x", value: [0, 1.3 * force,0.7, -1.3 * force, 0], duration: 1, repeatCount: 0, timingFunction: timingFunction), forKey: nil)
        forecastView.layer.add(self.shakeAnimation(keyPath: "position.y", value: [0, 0.7,1.3 * force,-0.7, 0], duration: 1, repeatCount: 0, timingFunction: timingFunction), forKey: nil)
        
        for UIImageView in forecastIconImageView {
            UIImageView.layer.add(self.shakeAnimation(keyPath: "position.x", value: [0, 1.3 * force,0.7, -1.3 * force, 0], duration: 2, repeatCount: 0, timingFunction: timingFunction), forKey: nil)
            UIImageView.layer.add(self.shakeAnimation(keyPath: "position.y", value: [0, 0.7,1.3 * force,-0.7, 0], duration: 2, repeatCount: 0, timingFunction: timingFunction), forKey: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getforecastWeatherFromServer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
//MARK: -Helped Methods
    
    func makeBlurEffectToView(view:UIView, effectStule:UIBlurEffectStyle) {
        view.backgroundColor = UIColor.clear
        let blurEffect:UIBlurEffect = UIBlurEffect(style: effectStule)
        let visualEffectView:UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        view.insertSubview(visualEffectView, at: 0)
    }
    
    func shakeAnimation(keyPath: String,value: [Any],duration:CFTimeInterval,repeatCount:Float,timingFunction:CAMediaTimingFunction) -> CAKeyframeAnimation {
        let shake = CAKeyframeAnimation(keyPath: keyPath)
        shake.values = value
        shake.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        shake.timingFunction = timingFunction
        shake.isAdditive = true
        shake.duration = duration
        shake.repeatCount = repeatCount
        shake.beginTime = CACurrentMediaTime() + 0
        return shake
    }
    
    func getforecastWeatherFromServer() {
        ServerManager.sharedManager.getOpenWeatherMapRequestForecastWithCityID(cityID:self.cityID,
                                                onSuccess: { (weatherObject) in
                                                    for index in 0...3 {
                                                    let timeText = weatherObject.timeArray[index]
                                                    let currentTimeLable:UILabel = self.forecastTimeLabel[index]
                                                    let temperature = weatherObject.temperatureArray[index]
                                                    let currentTempLable:UILabel = self.forecastTemperatureLabel[index]
                                                    currentTimeLable.text = timeText as? String
                                                    currentTempLable.text = String(describing: temperature)
                                                    }
                                                        DispatchQueue.main.async(execute: {
                                                            if !weatherObject.iconArray.isEmpty {
                                                            for index in 0...3 {
                                                            let iconArray = weatherObject.iconArray[index]
                                                            let currentIconLable = self.forecastIconImageView[index]
                                                            currentIconLable.image = iconArray as? UIImage
                                                            }
                                                            }
                                                        })
                                                    
        }, onFailure: {(error) in
        self.alertErrorDescription(erorr: (error?.localizedDescription)!)
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
}









