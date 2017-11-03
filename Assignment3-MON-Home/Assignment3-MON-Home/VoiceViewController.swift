//
//  VoiceViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 2/11/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit
import Speech
import CoreData

class VoiceViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var speechResult = SFSpeechRecognitionResult()
    
    var managedObjectContext:NSManagedObjectContext!
    
    var isClosedManually = false
    var devices = [Device]()
    
    @IBOutlet weak var voiceButton: UIButton!
    
    @IBAction func voiceButtonClicked(_ sender: Any) {
        if voiceButton.currentImage == #imageLiteral(resourceName: "microphoneOff") {
            voiceControlOn()
        } else if voiceButton.currentImage == #imageLiteral(resourceName: "microphoneOn") {
            isClosedManually = true
            voiceControlOff()
        }
    }
    
    func voiceControlOn() {
        checkAuthStatus()
    }
    
    func voiceControlOff() {
        stopRecording()
        checkForActionPhrases()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let deviceRequest:NSFetchRequest<Device> = Device.fetchRequest()
        
        do {
            devices = try managedObjectContext.fetch(deviceRequest)
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
    }
    
    func checkAuthStatus() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                var alertTitle = ""
                var alertMsg = ""
                
                switch authStatus {
                case .authorized:
                    do {
                        try self.startRecording()
                    } catch {
                        alertTitle = "Recorder Error"
                        alertMsg = "There was a problem starting the speech recorder"
                    }
                    
                case .denied:
                    alertTitle = "Speech recognizer not allowed"
                    alertMsg = "You need to enable the recgnizer in Settings"
                    
                case .restricted, .notDetermined:
                    alertTitle = "Could not start the speech recognizer"
                    alertMsg = "Check your internect connection and try again"
                    
                }
                if alertTitle != "" {
                    self.generateAlert(title: alertTitle, message: alertMsg)
                }
            }
        }
    }
    
    func startRecording() throws {
        let deviceRequest:NSFetchRequest<Device> = Device.fetchRequest()
        
        do {
            devices = try managedObjectContext.fetch(deviceRequest)
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        if !audioEngine.isRunning {
            let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(VoiceViewController.timerEnded), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: .commonModes)
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            let inputNode = audioEngine.inputNode
            guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create the recognition request") }
            
            recognitionRequest.shouldReportPartialResults = true
            
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                var isFinal = false
                
                if let result = result {
                    print("result: \(result.isFinal)")
                    isFinal = result.isFinal
                    
                    self.speechResult = result
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
            }
            print("Begin recording")
            audioEngine.prepare()
            try audioEngine.start()
            
            voiceButton.setImage(#imageLiteral(resourceName: "microphoneOn"), for: UIControlState.normal)
        }
    }
    
    @objc func timerEnded() {
        // If the audio recording engine is running stop it and remove the SFSpeechRecognitionTask
        if audioEngine.isRunning && !isClosedManually {
            stopRecording()
            checkForActionPhrases()
        } else {
            isClosedManually = false
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        // Cancel the previous task if it's running
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        voiceButton.setImage(#imageLiteral(resourceName: "microphoneOff"), for: UIControlState.normal)
    }
    
    var isContainsOn = false
    var isContainsOff = false
    func checkForActionPhrases() {
        isContainsOn = false
        isContainsOff = false
        let newString = speechResult.bestTranscription.formattedString.lowercased()
        if newString.contains("open") || newString.contains("on") {
            isContainsOn = true
        } else if newString.contains("close") || newString.contains("off") {
            isContainsOff = true
        }
        
        if isContainsOn {
            print("on")
            if findDeviceBySpeech() != "" {
                NodeServer.sharedInstance.setPowerForDeviceById(id: findDeviceBySpeech(), mode: "on")
            }
        } else if isContainsOff {
            print("off")
            if findDeviceBySpeech() != "" {
                NodeServer.sharedInstance.setPowerForDeviceById(id: findDeviceBySpeech(), mode: "off")
            }
        } else {
            generateAlert(title: "Commands are not detected", message: "It should contain On, Open, Off or Close as key words")
        }
        
        print(speechResult.bestTranscription.formattedString)
        speechResult = SFSpeechRecognitionResult()
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print("Recognizer availability changed: \(available)")
        if !available {
            generateAlert(title: "There was a problem accessing the recognizer", message: "Please try again later")
        }
    }
    
    func findDeviceBySpeech() -> String {
        var validDevices = [Device]()
        var id = ""
        print(devices.count)
        for each in devices {
            let name = each.name?.lowercased()
            var type = each.type?.lowercased()
            switch(each.type!) {
            case "power-plug":
                type = "socket"
                break
            case "power-plug-heater":
                type = "heater"
                break
            case "lamp":
                type = "lamp"
                break
            case "light":
                type = "light"
                break
            default:
                type = "unknow device"
                break
            }
            
            let newString = speechResult.bestTranscription.formattedString.lowercased()
            
            if newString.range(of: name!) != nil || newString.range(of: type!) != nil {
                validDevices.append(each)
            }
        }
        
        if validDevices.count == 0 {
            generateAlert(title: "Try again?", message: "There is no such device")
        } else if validDevices.count == 1 {
            id = validDevices[0].id!
        } else {
            let alertController = UIAlertController(title: "Which device do you want?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            for each in validDevices {
                alertController.addAction(UIAlertAction(title: each.name, style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    id = each.id!
                    if self.isContainsOn {
                        if id != "" {
                            NodeServer.sharedInstance.setPowerForDeviceById(id: id, mode: "on")
                        }
                    } else if self.isContainsOff {
                        print("off")
                        if id != "" {
                            NodeServer.sharedInstance.setPowerForDeviceById(id: id, mode: "off")
                        }
                    } else {
                        self.generateAlert(title: "Commands are not detected", message: "It should contain On, Open, Off or Close as key words")
                    }
                })
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        return id
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
