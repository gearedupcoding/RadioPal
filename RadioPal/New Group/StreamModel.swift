//
//  StreamModel.swift
//  RadioPal
//
//  Created by Jami, Dheeraj on 9/20/17.
//  Copyright © 2017 Jami, Dheeraj. All rights reserved.
//

import UIKit
import SwiftyJSON

class StreamModel: NSObject {
    var contentType: String?
    var status: Int?
    var listeners: Int?
    var stream: String?
    var bitrate: Int?
    
    init(json: JSON) {
        self.contentType = json["content_type"].string
        self.stream = json["stream"].string
        self.bitrate = json["bitrate"].int
        self.status = json["status"].int
        self.listeners = json["listeners"].int
    }
}
