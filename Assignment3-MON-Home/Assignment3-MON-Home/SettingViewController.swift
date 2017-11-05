//
//  SettingViewController.swift
//  Assignment3-MON-Home
//
//  Created by Mike Phan on 2/11/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

/////////////////////////////////////////////////////////////////////
//       This File create based on tutorial published by           //
//                   Author: Anton Meier                           //
//                Last Modified: 31 Dem 2016                       //
// Link: https://github.com/50ButtonsEach/ios-boilerplate-swift    //
//                                                                 //
//                   Flic API Documentation                        //
//                        Author: Flic                             //
// Link: https://partners.flic.io/partners/developers/ios-tutorial //
/////////////////////////////////////////////////////////////////////

import UIKit
import fliclib

class SettingViewController: UIViewController,SCLFlicManagerDelegate, SCLFlicButtonDelegate {
    
    @IBOutlet weak var gasSwitch: UISwitch!
    @IBOutlet weak var motionSwitch: UISwitch!
    
    @IBAction func gasSwitchChanged(_ sender: Any) {
        if(gasSwitch.isOn){
            NodeServer.sharedInstance.switchSensor(sensorName: "Gas", mode: "on")
        }else{
            NodeServer.sharedInstance.switchSensor(sensorName: "Gas", mode: "off")
        }
    }
    
    @IBAction func motionSwitchChanged(_ sender: Any) {
        if(motionSwitch.isOn){
            NodeServer.sharedInstance.switchSensor(sensorName: "Motion", mode: "on")
        }else{
            NodeServer.sharedInstance.switchSensor(sensorName: "Motion", mode: "off")
        }
    }
    
    func flicManager(_ manager: SCLFlicManager, didGrab button: SCLFlicButton?, withError error: Error?) {
        button?.triggerBehavior = SCLFlicButtonTriggerBehavior.clickAndDoubleClickAndHold
        
    }
    
    @IBOutlet weak var labelStatus: UILabel!
    @IBAction func connectFlicButtonClick(_ sender: Any) {
        print("Grabbing a flic..")
        SCLFlicManager.shared()?.grabFlicFromFlicApp(withCallbackUrlScheme: "ios-mon-home-swift")
    }

    // THIS KEY HAS BEEN CREATED BY MINH PHAN ON FLIC DEVELOPER PAGE
    // Link: https://partners.flic.io/partners/developers/credentials
    // Account: hminh1208@gmail.com
    let SCL_APP_ID: String = "db4fd51f-c011-4a7f-8692-0038de7e034a"
    let SCL_APP_SECRET: String = "5bedbed9-3871-4355-825f-9cc506e6a13e"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SCLFlicManager.configure(with: self, defaultButtonDelegate: self, appID: SCL_APP_ID, appSecret: SCL_APP_SECRET, backgroundExecution: true)
        
        prepareUI()
    }
    
    func flicManager(_ manager: SCLFlicManager, didChange state: SCLFlicManagerBluetoothState) {
        // TODO: Handle bluetooth state changes.
        print("Did change bluetooth state: \(state.rawValue)")
    }
    
    func flicManagerDidRestoreState(_ manager: SCLFlicManager) {
        print("Did restore state")
    }
    
    // --- SCLFlicButtonDelegate methods ---
    
    func flicButtonDidConnect(_ button: SCLFlicButton) {
        labelStatus.text = "Connected to \(button.name)"
    }
    
    func flicButtonIsReady(_ button: SCLFlicButton) {
        print("Flic is ready")
    }
    
    func flicButton(_ button: SCLFlicButton, didDisconnectWithError error: Error?) {
        labelStatus.text = "Disconnected from \(button.name)"
    }
    
    func flicButton(_ button: SCLFlicButton, didFailToConnectWithError error: Error?) {
        print("Did fail to connect Flic")
        if (error != nil) {
            if (error!._code == SCLFlicError.buttonIsPrivate.rawValue) {
                SCLFlicManager.shared()?.forget(button)
            }
        }
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonClick queued: Bool, age: Int) {
        NodeServer.sharedInstance.singleClicked()
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
         NodeServer.sharedInstance.doubleClicked()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareUI(){
        NodeServer.sharedInstance.getCurrentStateSensors(completionHandler: { sensors, error in
            if let error = error {
                // got an error in getting the data, need to handle it
                print(error)
                return
            }
            guard let sensors = sensors else {
                print("error getting first todo: result is nil")
                return
            }
            // success
            if(sensors.gas){
                
                self.setState(sensor: self.gasSwitch, mode: true)
            }else{
                self.setState(sensor: self.gasSwitch, mode: false)
            }
            
            if(sensors.motion){
                self.setState(sensor: self.motionSwitch, mode: true)
            }else{
                self.setState(sensor: self.motionSwitch, mode: false)
            }
        });
    }
    
    func setState(sensor: UISwitch, mode: Bool){
        DispatchQueue.main.async {
            sensor.isOn = mode
        }
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
