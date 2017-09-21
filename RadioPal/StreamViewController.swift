//
//  StreamViewController.swift
//  RadioPal
//
//  Created by Jami, Dheeraj on 9/20/17.
//  Copyright © 2017 Jami, Dheeraj. All rights reserved.
//

import UIKit
import Jukebox

class StreamViewController: UIViewController, JukeboxDelegate {
    var station: StationModel?
    var index: Int?
    var jukebox : Jukebox!

    init(station: StationModel) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .cyan
        // configure jukebox
        
        if let station = self.station, let streamStr = station.stream[0].stream,
            let urlStr =  URL(string: streamStr) {
            jukebox = Jukebox(delegate: self, items: [
                JukeboxItem(URL: urlStr)
                ])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
        self.jukebox.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.jukebox.stop()
    }
    
    private func setupUI() {
        let label = UILabel().then {
            
            self.view.addSubview($0)
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.text = self.station?.name?.capitalized
            $0.font = UIFont.systemFont(ofSize: 30)
            
            $0.snp.makeConstraints { (make) in
                make.center.equalTo(self.view)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        print("Jukebox did load: \(item.URL.lastPathComponent)")
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        
        if let currentTime = jukebox.currentItem?.currentTime, let duration = jukebox.currentItem?.meta.duration {
            let value = Float(currentTime / duration)
            //            slider.value = value
            //            populateLabelWithTime(currentTimeLabel, time: currentTime)
            //            populateLabelWithTime(durationLabel, time: duration)
        } else {
            //resetUI()
        }
    }
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            //            self.indicator.alpha = jukebox.state == .loading ? 1 : 0
            //            self.playPauseButton.alpha = jukebox.state == .loading ? 0 : 1
            //            self.playPauseButton.isEnabled = jukebox.state == .loading ? false : true
        })
        
        if jukebox.state == .ready {
            // playPauseButton.setImage(UIImage(named: "playBtn"), for: UIControlState())
        } else if jukebox.state == .loading  {
            // playPauseButton.setImage(UIImage(named: "pauseBtn"), for: UIControlState())
        } else {
            // volumeSlider.value = jukebox.volume
            let imageName: String
            switch jukebox.state {
            case .playing, .loading:
                imageName = "pauseBtn"
            case .paused, .failed, .ready:
                imageName = "playBtn"
            }
            //playPauseButton.setImage(UIImage(named: imageName), for: UIControlState())
        }
        
        print("Jukebox state changed to \(jukebox.state)")
    }
    
    func jukeboxDidUpdateMetadata(_ jukebox: Jukebox, forItem: JukeboxItem) {
        print("Item updated:\n\(forItem)")
    }
    
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay :
                jukebox.play()
            case .remoteControlPause :
                jukebox.pause()
            case .remoteControlNextTrack :
                jukebox.playNext()
            case .remoteControlPreviousTrack:
                jukebox.playPrevious()
            case .remoteControlTogglePlayPause:
                if jukebox.state == .playing {
                    jukebox.pause()
                } else {
                    jukebox.play()
                }
            default:
                break
            }
        }
    }

}
