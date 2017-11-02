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
    var isClosedManually = false
    
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
        
        // Do any additional setup after loading the view.
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
            
            // Configure request so that results are returned before audio recording is finished
            recognitionRequest.shouldReportPartialResults = true
            
            // A recognition task is used for speech recognition sessions
            // A reference for the task is saved so it can be cancelled
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
    
    func checkForActionPhrases() {
        var isContainsOn = false
        var isContainsOff = false
        
        let newString = speechResult.bestTranscription.formattedString.lowercased()
        if newString.contains("open") || newString.contains("on") {
            isContainsOn = true
        } else if newString.contains("close") || newString.contains("off") {
            isContainsOff = true
        }
        
        if isContainsOn {
            print("on")
        } else if isContainsOff {
            print("off")
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
