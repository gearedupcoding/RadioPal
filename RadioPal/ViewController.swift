//
//  ViewController.swift
//  RadioPal
//
//  Created by Jami, Dheeraj on 9/20/17.
//  Copyright © 2017 Jami, Dheeraj. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Speech
import Alamofire

@available(iOS 10.0, *)
class ViewController: UIViewController {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var micBtn = UIButton(type: .custom)
 
    //Speech Recognition
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        self.title = "RadioPal"
        self.setupUI()
        self.speechRecognizer?.delegate = self
        self.requestAuthorization()
    }
    
    private func setupUI() {
        
        let label = UILabel().then {
            
            self.view.addSubview($0)
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.text = "Welcome to RadioPal"
            $0.font = UIFont.systemFont(ofSize: 30)
            
            $0.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view)
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            }
        }
        
        let instructionsLabel = UILabel().then {
            self.view.addSubview($0)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.text = "Click on mic icon to speak - Say a genre or country to list out the stations. Go ahead!"
            $0.font = UIFont.systemFont(ofSize: 25)
            
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(label)
                make.top.equalTo(label.snp.bottom).offset(10)
                make.left.equalTo(self.view).offset(15)
                make.right.equalTo(self.view).offset(-15)
            })
        }
        
        self.micBtn.do {
            self.view.addSubview($0)
            let micImage = UIImage(named: "mic")
            $0.setImage(micImage, for: .normal)
            $0.addTarget(self, action: #selector(micBtnPressed(_:)), for: .touchUpInside)
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(instructionsLabel)
                make.height.width.equalTo((micImage?.size.width)!)
                make.top.equalTo(instructionsLabel.snp.bottom).offset(20)
            })
        }
        self.micBtn.isEnabled = false

    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.micBtn.isEnabled = isButtonEnabled
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func micBtnPressed(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            micBtn.isEnabled = false
            micBtn.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            micBtn.setTitle("Stop Recording", for: .normal)
        }
    }

    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = false
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                print(result?.bestTranscription.formattedString)
                //self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.micBtn.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            micBtn.isEnabled = true
        } else {
            micBtn.isEnabled = false
        }
    }

}

extension ViewController: SFSpeechRecognizerDelegate {
    
}

