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
    
    @IBAction func powerSwitchAction(_ sender: Any) {
        if(powerSwitch.isOn){
            NodeServer.sharedInstance.setPowerForDeviceById(id: (thisDevice?.id)!, mode: "on")
        }else{
            NodeServer.sharedInstance.setPowerForDeviceById(id: (thisDevice?.id)!, mode: "off")
        }
    }
    
    @IBAction func discardChangeClicked(_ sender: Any) {
    }
    
    @IBAction func saveChangeClicked(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        prepareUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareUI(){
        NodeServer.sharedInstance.getAllDeviceInfo(completionHandler: { devices, error in
            if let error = error {
                // got an error in getting the data, need to handle it
                print(error)
                return
            }
            guard let devices = devices else {
                print("error getting first todo: result is nil")
                return
            }
            // success
            for device in devices{
                if(device.id == self.thisDevice?.id){
                    
                    DispatchQueue.main.async {
                        self.powerSwitch.isOn = device.isPowerOn
                    }
                    
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
