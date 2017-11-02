//
//  VoiceViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 2/11/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit
import Speech

class VoiceViewController: UIViewController {

    @IBOutlet weak var voiceButton: UIButton!
    
    @IBAction func voiceButtonClicked(_ sender: Any) {
        if voiceButton.currentImage == #imageLiteral(resourceName: "microphoneOff") {
            voiceControlOn()
        } else if voiceButton.currentImage == #imageLiteral(resourceName: "microphoneOn") {
            voiceControlOff()
        }
    }
    
    func voiceControlOn() {
        voiceButton.setImage(#imageLiteral(resourceName: "microphoneOn"), for: UIControlState.normal)
    }
    
    func voiceControlOff() {
        voiceButton.setImage(#imageLiteral(resourceName: "microphoneOff"), for: UIControlState.normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
