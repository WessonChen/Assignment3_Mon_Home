//
//  SocketViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 30/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit

class SocketViewController: UIViewController {

    var thisDevice: Device?
    var deviceSetting: NodeServer.DeviceSetting?
    
    @IBOutlet weak var fromTimePicker: UIDatePicker!
    @IBOutlet weak var toTimePicker: UIDatePicker!
    @IBOutlet weak var enableSettingSwitch: UISwitch!
    @IBOutlet weak var powerSwitch: UISwitch!
    
    let dateFormatter:DateFormatter = DateFormatter()

    @IBAction func fromDatePickerChanged(_ sender: Any) {
        toTimePicker.minimumDate = fromTimePicker.date
    }
    
    
    //Turn on/off device
    @IBAction func powerSwitchAction(_ sender: Any) {
        if(powerSwitch.isOn){
            NodeServer.sharedInstance.setPowerForDeviceById(id: (thisDevice?.id)!, mode: "on")
        }else{
            NodeServer.sharedInstance.setPowerForDeviceById(id: (thisDevice?.id)!, mode: "off")
        }
    }
    
    
    //Canceled set config
    @IBAction func discardChangeClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //Save config for this device
    @IBAction func saveChangeClicked(_ sender: Any) {
        
        let setting = NodeServer.DeviceSetting(id: (thisDevice?.id)!, startTime: dateFormatter.string(from: fromTimePicker.date), stopTime: dateFormatter.string(from: toTimePicker.date), minTemp: "0", maxTemp: "0", brightness: 0, isPowerOn: powerSwitch.isOn, isOnPeriod: false, isSettingEnabled: enableSettingSwitch.isOn, type: (thisDevice?.type)!, isManuallyControlled: false)
        
        NodeServer.sharedInstance.setDeviceSettingById(deviceSetting: setting, completionHandler: {error in
            if let error = error {
                // got an error in getting the data, need to handle it
                print(error)
                return
            }
        })
        
        generateAlert(message: "Setting has been saved successfully")
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat =  "HH:mm"
        
        prepareUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get current config from back-end
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
                    self.fromTimePicker.date = self.dateFormatter.date(from: device.startTime)!
                    self.toTimePicker.date = self.dateFormatter.date(from: device.stopTime)!
                    self.enableSettingSwitch.isOn = device.isSettingEnabled
                }
            }
            
        })
    }

    func generateAlert(message: String){
        let alertController = UIAlertController(title: "Setting Saved", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
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
