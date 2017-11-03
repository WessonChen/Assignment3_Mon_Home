//
//  HeaterViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 30/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit

class HeaterViewController: UIViewController, UITextFieldDelegate {

    var thisDevice: Device?
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var fromTemperature: UITextField!
    @IBOutlet weak var toTemperature: UITextField!
    @IBOutlet weak var enableSettingSwitch: UISwitch!
    @IBOutlet weak var powerSwitch: UISwitch!
    
    let dateFormatter:DateFormatter = DateFormatter()
    var defaultY: CGFloat = 0.0
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let setting = NodeServer.DeviceSetting(id: (thisDevice?.id)!, startTime: dateFormatter.string(from: fromDatePicker.date), stopTime: dateFormatter.string(from: toDatePicker.date), minTemp: (fromTemperature.text)!, maxTemp: (toTemperature.text)!, brightness: 0, isPowerOn: powerSwitch.isOn, isOnPeriod: false, isSettingEnabled: enableSettingSwitch.isOn, type: (thisDevice?.type)!, isManuallyControlled: false)
        
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
    
    @IBAction func discardButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fromDatePickerChanged(_ sender: Any) {
        toDatePicker.minimumDate = fromDatePicker.date
    }
    
    @IBAction func powerSwitchChanged(_ sender: Any) {
        if(powerSwitch.isOn){
            NodeServer.sharedInstance.setPowerForDeviceById(id: (thisDevice?.id)!, mode: "on")
        }else{
            NodeServer.sharedInstance.setPowerForDeviceById(id: (thisDevice?.id)!, mode: "off")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatter.dateFormat =  "HH:mm"
        prepareUI()
        
        /*
         Get the height of the keyboard
         From: https://stackoverflow.com/questions/31774006/how-to-get-height-of-keyboard-swift
         Author: Nrv
         */
        
        NotificationCenter.default.addObserver(self, selector: #selector(RoomTableViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RoomTableViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        defaultY = self.view.center.y
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
                    self.fromTemperature.text = device.minTemp
                    self.toTemperature.text = device.maxTemp
                    self.enableSettingSwitch.isOn = device.isSettingEnabled
                }
            }
            
        })
    }
    
    
    
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.view.center.y = keyboardHeight
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.center.y = defaultY
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if fromTemperature.isEditing {
            fromTemperature.resignFirstResponder()
        }
        if toTemperature.isEditing {
            toTemperature.resignFirstResponder()
        }
        return true
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
