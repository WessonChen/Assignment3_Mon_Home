//
//  LaunchViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 4/11/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

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
        return 3
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descirptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        return [(#imageLiteral(resourceName: "rocket"), "A Great Rocket Start", "Caramels cheesecake bonbon bonbon topping. Candy halvah cotton candy chocolate bar cake. Fruitcake liquorice candy canes marshmallow topping powder.", #imageLiteral(resourceName: "circle"), backgroundColorOne, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                (#imageLiteral(resourceName: "brush"), "Design your Experience", "Caramels cheesecake bonbon bonbon topping. Candy halvah cotton candy chocolate bar cake. Fruitcake liquorice candy canes marshmallow topping powder.", #imageLiteral(resourceName: "circle"), backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                (#imageLiteral(resourceName: "notification"), "Stay Up To Date", "Get notified of important updates.", #imageLiteral(resourceName: "circle"), backgroundColorThree, UIColor.white, UIColor.white, titleFont, descirptionFont)][index]
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
