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
import SwiftyJSON
import Alamofire

@available(iOS 10.0, *)
let token = "token=77c624783e5f4fe9af9e9c3bb3"
class ViewController: UIViewController {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var micBtn = UIButton(type: .custom)
    var genres = [GenreModel]()
    var stations = [StationModel]()
    var genresDict = [String: String]()
    var countriesDict = [String: String]()
    var recordedText = ""
    
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
        self.getGenres()
        
        //Genres
        genresDict["Rock"] = "2"
        genresDict["Jazz"] = "12"
        
        //Countries
        countriesDict["UK"] = "GB"
        countriesDict["Germany"] = "DE"
        countriesDict["US"] = "US"
        
        print(genresDict)
        print(countriesDict)
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
                make.centerX.equalTo(self.view)
                make.height.width.equalTo((micImage?.size.width)!)
                make.bottom.equalTo(self.view).offset(-20)
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
                if let resultText = (result?.bestTranscription.formattedString) {
                    self.recordedText = resultText
                    self.search(recordedString: self.recordedText)
                }
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

extension ViewController {
    //Alamofire
    func searchForGenreStations(genreId: String) {
        let genreURL = "http://api.dirble.com/v2/category/\(genreId)/stations?"
        let url = genreURL + "\(token)"
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func search(recordedString: String) {
        if let genreid = self.genresDict[recordedString] {
            self.searchForGenreStations(genreId: genreid)
        } else if let countryCode = self.countriesDict[recordedString] {
            self.searchForCountryStations(countryCode: countryCode)
        }
    }
    
    func searchForCountryStations(countryCode: String) {
        let countryURL = "http://api.dirble.com/v2/countries/\(countryCode)/stations?"
        let url = countryURL + "\(token)"
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json[0])
                print(json[0]["streams"])
                for jsonCountry in json {
                    let stationModel = StationModel(json: jsonCountry)
                    self.stations.append(stationModel)
                }
                let vc = StationsViewController(stations: self.stations)
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension ViewController: SFSpeechRecognizerDelegate {
    func getGenres() {
        if let path = Bundle.main.url(forResource: "genres", withExtension: "json"), let json = try? Data(contentsOf: path) {
            let jsonArray = JSON.init(arrayLiteral: json)
            for json in jsonArray[0] {
                let genreJSON = json.1
                let genre = GenreModel(json: genreJSON)
                self.genres.append(genre)
            }
            print(self.genres.count)
        }
    }
    
    func getCountries() {
            
    }
    
    private func readJson(name: String) -> [Any]? {
        var returnObject = [Any]()
        do {
            if let file = Bundle.main.url(forResource: name, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    returnObject = object
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return returnObject
    }

}

