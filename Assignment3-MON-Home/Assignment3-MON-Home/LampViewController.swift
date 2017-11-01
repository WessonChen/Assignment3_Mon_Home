//
//  LampViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 30/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit

class LampViewController: UIViewController {

    var thisDevice: Device?
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    @IBOutlet weak var brightnessSlider: UISlider!
    
    @IBOutlet weak var enableSettingSwitch: UISwitch!
    @IBOutlet weak var powerSwitch: UISwitch!
    
    @IBAction func discardButtonClicker(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func brightnessChanged(_ sender: Any) {
        
    }
    
    @IBAction func fromDatePickerChanged(_ sender: Any) {
        toDatePicker.minimumDate = fromDatePicker.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
