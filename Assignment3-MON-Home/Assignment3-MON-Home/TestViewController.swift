//
//  TestViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 27/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    let host: String = "http://192.168.0.10"
    let port: String = ":3000"
    let setPower = "/setPower/"
    let id = "44794198/"
    
    @IBAction func dateFromPicker(_ sender: Any) {
    }
    
    @IBAction func dateToPicker(_ sender: Any) {
    }
    
    @IBAction func brightnessSlider(_ sender: Any) {
    }
    
    @IBOutlet weak var powerSwitchOutlet: UISwitch!
    
    @IBAction func powerSwitch(_ sender: Any) {
        // Set up the URL request
        var todoEndpoint: String = ""
        if powerSwitchOutlet.isOn {
             todoEndpoint = host + port + setPower + id + "on"
        }else{
            todoEndpoint = host + port + setPower + id + "off"
        }
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
        }
        task.resume()
    }
    
    @IBAction func smartFunctionSwitch(_ sender: Any) {
    }
    
    @IBAction func saveButton(_ sender: Any) {
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
