//
//  WeatherViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 25/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var GifBackground: UIImageView!
    @IBOutlet weak var CItyLabel: UILabel!
    @IBOutlet weak var ConditionLabel: UILabel!
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var ConditionImage: UIImageView!
    @IBOutlet var SettingView: UIView!
    @IBOutlet weak var VisualEffectView: UIVisualEffectView!
    @IBOutlet weak var setLocationText: UITextField!
    
    var effect:UIVisualEffect!
    var lo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lo = setLocationText.text!
        if self.lo == "" {
            self.lo = "Melbourne"
        }
        
        CItyLabel.text = self.lo
        displayWeather(location: self.lo)
        
        effect = VisualEffectView.effect
        VisualEffectView.effect = nil
        SettingView.layer.cornerRadius = 5
    }
    
    func animateIn() {
        self.view.addSubview(SettingView)
        SettingView.center = self.view.center
        
        SettingView.transform = CGAffineTransform.init(translationX: 1.3, y: 1.3)
        SettingView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffectView.effect = self.effect
            self.SettingView.alpha = 1
            self.SettingView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.SettingView.transform = CGAffineTransform.init(translationX: 1.3, y: 1.3)
            self.SettingView.alpha = 0
            self.VisualEffectView.effect = nil
        }) {(success:Bool) in
            self.SettingView.removeFromSuperview()
        }
    }
    
    @IBAction func setLocation(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        animateOut()
        viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var lo = setLocationText.text!
        if lo == "" {
            lo = "Melbourne"
        }
        if(segue.identifier == "moreWeatherSegue") {
            if let destinationVC = segue.destination as? WeatherTableViewController {
                destinationVC.location = lo
            }
        }
    }
    
    func displayWeather (location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        if let weatherData = results {
                            self.TempLabel.text = "\(Int(weatherData[0].temperature))°C"
                            switch (weatherData[0].icon) {
                            case "clear-day":
                                self.ConditionLabel.text = "Sunny"
                                self.ConditionImage.image = #imageLiteral(resourceName: "clear-day")
                                self.GifBackground.loadGif(name: "sunnyGif")
                                break
                            case "clear-night":
                                self.ConditionLabel.text = "Sunny"
                                self.ConditionImage.image = #imageLiteral(resourceName: "clear-night")
                                self.GifBackground.loadGif(name: "sunnyGif")
                                break
                            case "cloudy":
                                self.ConditionLabel.text = "Cloudy"
                                self.ConditionImage.image = #imageLiteral(resourceName: "cloudy")
                                self.GifBackground.loadGif(name: "cloudyGif")
                                break
                            case "fog":
                                self.ConditionLabel.text = "Fog"
                                self.ConditionImage.image = #imageLiteral(resourceName: "fog")
                                self.GifBackground.loadGif(name: "fogGif")
                                break
                            case "partly-cloudy-day":
                                self.ConditionLabel.text = "Cloudy"
                                self.ConditionImage.image = #imageLiteral(resourceName: "partly-cloudy-day")
                                self.GifBackground.loadGif(name: "cloudyGif")
                                break
                            case "partly-cloudy-night":
                                self.ConditionLabel.text = "Cloudy"
                                self.ConditionImage.image = #imageLiteral(resourceName: "partly-cloudy-night")
                                self.GifBackground.loadGif(name: "cloudyGif")
                                break
                            case "rain":
                                self.ConditionLabel.text = "Rain"
                                self.ConditionImage.image = #imageLiteral(resourceName: "rain")
                                self.GifBackground.loadGif(name: "rainGif")
                                break
                            case "sleet":
                                self.ConditionLabel.text = "Sleet"
                                self.ConditionImage.image = #imageLiteral(resourceName: "sleet")
                                break
                            case "snow":
                                self.ConditionLabel.text = "Snow"
                                self.ConditionImage.image = #imageLiteral(resourceName: "snow")
                                break
                            case "wind":
                                self.ConditionLabel.text = "wind"
                                self.ConditionImage.image = #imageLiteral(resourceName: "wind")
                                break
                            default:
                                break
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
