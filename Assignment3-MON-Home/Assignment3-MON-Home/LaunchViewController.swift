//
//  LaunchViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 4/11/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//


///////////////////////////////////////////////////////////////////
//                      Paper-onboarding                         //
//                      Author: Ramotion                         //
// Link: https://github.com/Ramotion/paper-onboarding            //
///////////////////////////////////////////////////////////////////


import UIKit
import PaperOnboarding

class LaunchViewController: UIViewController, PaperOnboardingDataSource {

    @IBOutlet weak var onboardingView: OnboardingView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        let backgroundColorFour = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descirptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        return [(#imageLiteral(resourceName: "launchHome"), "Smart Home", "Add then config your devices.", #imageLiteral(resourceName: "circle"), backgroundColorOne, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                (#imageLiteral(resourceName: "launchWeather"), "Weather", "Check the current weather and the weather forecase.", #imageLiteral(resourceName: "circle"), backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                (#imageLiteral(resourceName: "launchVoice"), "Voice Control", "Turn on/off your devices by voice.", #imageLiteral(resourceName: "circle"), backgroundColorThree, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                (#imageLiteral(resourceName: "launchSetting"), "Settings", "Add flic button to control your devices and config your sensors.", #imageLiteral(resourceName: "circle"), backgroundColorFour, UIColor.white, UIColor.white, titleFont, descirptionFont)][index]
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    @IBAction func started(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onboardingComplete")
        userDefaults.synchronize()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
