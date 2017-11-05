//
//  WeatherViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 25/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate {

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
        self.setLocationText.delegate = self
        self.lo = setLocationText.text!
        if self.lo == "" {
            self.lo = "Melbourne"
        }
        
        CItyLabel.text = self.lo
        displayWeather(location: self.lo)
        
        effect = VisualEffectView.effect
        VisualEffectView.effect = nil
        SettingView.layer.cornerRadius = 5
        
        /*
         Get the height of the keyboard
         From: https://stackoverflow.com/questions/31774006/how-to-get-height-of-keyboard-swift
         Author: Nrv
         */
        
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        viewDidLoad()
        animateOut()
    }
    
    @IBAction func cancelSave(_ sender: Any) {
        animateOut()
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
                            switch (weatherData[0].icon) {
                            case "clear-day":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Sunny", image: #imageLiteral(resourceName: "clear-day"), gifName: "sunnyGif")
                                break
                            case "clear-night":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Sunny", image: #imageLiteral(resourceName: "clear-night"), gifName: "sunnyGif")
                                break
                            case "cloudy":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Cloudy", image: #imageLiteral(resourceName: "cloudy"), gifName: "cloudyGif")
                                break
                            case "fog":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Fog", image: #imageLiteral(resourceName: "fog"), gifName: "fogGif")
                                break
                            case "partly-cloudy-day":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Cloudy", image: #imageLiteral(resourceName: "partly-cloudy-day"), gifName: "cloudyGif")
                                break
                            case "partly-cloudy-night":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Cloudy", image: #imageLiteral(resourceName: "partly-cloudy-night"), gifName: "cloudyGif")
                                break
                            case "rain":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Rain", image: #imageLiteral(resourceName: "rain"), gifName: "rainGif")
                                break
                            case "sleet":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Sleet", image: #imageLiteral(resourceName: "sleet"), gifName: "rainGif")
                                break
                            case "snow":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Snow", image: #imageLiteral(resourceName: "snow"), gifName: "rainGif")
                                break
                            case "wind":
                                self.changeLayout(temperature: weatherData[0].temperature, condition: "Windy", image: #imageLiteral(resourceName: "wind"), gifName: "cloudyGif")
                                break
                            default:
                                break
                            }
                        }else{
                                let alertController = UIAlertController(title: "Location Not Found", message: "Your city could not be found. Please try again!", preferredStyle: UIAlertControllerStyle.alert)
                                
                                alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                                    alertController.dismiss(animated: true, completion: nil)
                                }))
                                
                                self.present(alertController, animated: true, completion: nil)
                            
                        }
                    })
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        SettingView.center.y = keyboardHeight
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        SettingView.center = self.view.center
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setLocationText.resignFirstResponder()
        return true
    }
    
    func changeLayout(temperature: Double, condition: String, image: UIImage ,gifName: String){
        DispatchQueue.main.async {
            self.TempLabel.text = "\(Int(temperature))°C"
            self.ConditionLabel.text = condition
            self.ConditionImage.image = image
            self.GifBackground.loadGif(name: gifName)
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
