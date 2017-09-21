//
//  StreamViewController.swift
//  RadioPal
//
//  Created by Jami, Dheeraj on 9/20/17.
//  Copyright © 2017 Jami, Dheeraj. All rights reserved.
//

import UIKit
import Jukebox
import Alamofire
protocol StreamViewControllerDelegate: class {
    func setTitle(str: String)
}

class StreamViewController: UIViewController, JukeboxDelegate {
    var station: StationModel?
    var index: Int?
    var jukebox : Jukebox?
    var image: UIImage?
    var slideLabel = UILabel()
    var imageView = UIImageView()
    var isPaused = false
    var isStopped = false
    weak var delegate: StreamViewControllerDelegate?
    
    init(station: StationModel) {
        super.init(nibName: nil, bundle: nil)
        self.station = station
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .lightGray
        // configure jukebox
        self.delegate?.setTitle(str:"Tuning...")
        if let station = self.station, let streamStr = station.stream[0].stream,
            let urlStr =  URL(string: streamStr) {
            jukebox = Jukebox(delegate: self, items: [
                JukeboxItem(URL: urlStr)
                ])
        }
        
        self.setupUI()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.slideLabel.isHidden = true
        self.jukebox?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.jukebox?.stop()
    }
    
    private func setupUI() {

        let pauseView = UIView().then {
            self.view.addSubview($0)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pause(_:)))
            $0.addGestureRecognizer(tapGesture)
            $0.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(self.view)
                make.height.equalTo(self.view).dividedBy(2)
            })
        }
        
        let stopView = UIView().then {
            self.view.addSubview($0)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stop(_:)))
            $0.addGestureRecognizer(tapGesture)
            $0.snp.makeConstraints({ (make) in
                make.bottom.left.right.equalTo(self.view)
                make.height.equalTo(self.view).dividedBy(2)
            })
        }
        
        
        let label = UILabel().then {
            self.view.addSubview($0)
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.text = self.station?.name?.capitalized
            $0.font = UIFont.systemFont(ofSize: 30)
            self.view.bringSubview(toFront: $0)
            $0.textAlignment = .center
            
            $0.snp.makeConstraints { (make) in
                make.center.equalTo(self.view)
                make.left.equalTo(self.view).offset(15)
                make.right.equalTo(self.view).offset(-15)
            }
        }
        
        let slideLabel = UILabel().then {
            self.view.addSubview($0)
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.text = "<-- Slide to change -->"
            $0.font = UIFont.systemFont(ofSize: 30)
            $0.textAlignment = .center
            self.view.bringSubview(toFront: $0)
            
            $0.snp.makeConstraints { (make) in
                make.left.equalTo(self.view).offset(15)
                make.right.equalTo(self.view).offset(-15)
                make.bottom.equalTo(self.view).offset(-15)
            }
        }
    }
    
    @objc func pause(_ sender: UITapGestureRecognizer) {
        if self.isPaused {
            self.delegate?.setTitle(str:"Playing...")
            self.jukebox?.play()
            self.isPaused = false
            return
        }
        self.delegate?.setTitle(str:"Paused...")
        self.isPaused = true
        self.jukebox?.pause()
    }
    
    @objc func stop(_ sender: UITapGestureRecognizer) {
        if self.isStopped {
            self.delegate?.setTitle(str:"Playing...")
            self.jukebox?.play()
            self.isStopped = false
            return
        }
        self.delegate?.setTitle(str:"Stopped...")
        self.isStopped = true
        self.jukebox?.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        self.delegate?.setTitle(str:"Playing...")
        print("Jukebox did load: \(item.URL.lastPathComponent)")
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {

    }
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
    
    }
    
    func jukeboxDidUpdateMetadata(_ jukebox: Jukebox, forItem: JukeboxItem) {
        print("Item updated:\n\(forItem)")
    }
    
    
    override func remoteControlReceived(with event: UIEvent?) {

    }

}
