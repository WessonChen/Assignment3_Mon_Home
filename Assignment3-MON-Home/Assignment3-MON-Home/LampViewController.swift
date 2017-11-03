//
//  LampViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 30/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit
import fliclib

class LampViewController: UIViewController {
    
    var thisDevice: Device?
    let dateFormatter:DateFormatter = DateFormatter()
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var enableSettingSwitch: UISwitch!
    @IBOutlet weak var powerSwitch: UISwitch!
    
    @IBAction func discardButtonClicker(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func powerSwitchChanged(_ sender: Any) {
        if(powerSwitch.isOn){
            NodeServer.sharedInstance.setPowerForDeviceById(id: (thisDevice?.id)!, mode: "on")
        }else{
            NodeServer.sharedInstance.setPowerForDeviceById(id: (thisDevice?.id)!, mode: "off")
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        NodeServer.sharedInstance.setBrightnessForDeviceById(id: (thisDevice?.id)!, brightnessLevel: Int(brightnessSlider.value * 100) )
    
        let setting = NodeServer.DeviceSetting(id: (thisDevice?.id)!, startTime: dateFormatter.string(from: fromDatePicker.date), stopTime: dateFormatter.string(from: toDatePicker.date), minTemp: "0", maxTemp: "0", brightness: Int(brightnessSlider.value * 100), isPowerOn: powerSwitch.isOn, isOnPeriod: false, isSettingEnabled: enableSettingSwitch.isOn, type: (thisDevice?.type)!, isManuallyControlled: false)
        
        NodeServer.sharedInstance.setDeviceSettingById(deviceSetting: setting, completionHandler: {error in
            if let error = error {
                // got an error in getting the data, need to handle it
                print(error)
                return
            }
        })
    }
    
    @IBAction func brightnessChanged(_ sender: Any) {
     
    }
    
    @IBAction func fromDatePickerChanged(_ sender: Any) {
        toDatePicker.minimumDate = fromDatePicker.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatter.dateFormat =  "HH:mm"
        prepareUI()
        
        //
//
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareUI(){
        NodeServer.sharedInstance.getDeviceSettingById(id: (thisDevice?.id)!, completionHandler: { devices, error in
            if let error = error {
                // got an error in getting the data, need to handle it
                print(error)
                return
            }
            guard let device = devices else {
                print("error getting first todo: result is nil")
                return
            }
            // success
            if(device.id == self.thisDevice?.id){
                DispatchQueue.main.async {
                    self.powerSwitch.isOn = device.isPowerOn
                    self.fromDatePicker.date = self.dateFormatter.date(from: device.startTime)!
                    self.toDatePicker.date = self.dateFormatter.date(from: device.stopTime)!
                    self.brightnessSlider.value = Float(device.brightness) / 100
                    self.enableSettingSwitch.isOn = device.isSettingEnabled
                }
            }
        })
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
