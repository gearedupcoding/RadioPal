//
//  StationModel.swift
//  RadioPal
//
//  Created by Jami, Dheeraj on 9/20/17.
//  Copyright © 2017 Jami, Dheeraj. All rights reserved.
//

import UIKit
import SwiftyJSON
/*
 {
 "id" : 57400,
 "total_listeners" : 0,
 "categories" : [
 {
 "id" : 5,
 "title" : "Pop",
 "slug" : "pop",
 "description" : "stations that normally play pop-music",
 "ancestry" : null
 }
 ],
 "streams" : [
 {
 "content_type" : "audio\/mpeg",
 "status" : 1,
 "listeners" : 0,
 "stream" : "http:\/\/server1.usatelk.com:26990\/",
 "bitrate" : 64
 }
 ],
 "created_at" : "2017-09-17T08:33:47+02:00",
 "image" : {
 "url" : "https:\/\/img.dirble.com\/station\/57400\/d604bc46-34e7-4acc-9e91-8e485b5710da.jpg",
 "thumb" : {
 "url" : "https:\/\/img.dirble.com\/station\/57400\/thumb_d604bc46-34e7-4acc-9e91-8e485b5710da.jpg"
 }
 },
 "slug" : "alianza-internacional-de-radio",
 "updated_at" : "2017-09-17T08:33:48+02:00",
 "facebook" : "https:\/\/www.facebook.com\/AlianzaInternacionaldeRadio\/",
 "website" : "http:\/\/alianzainternacionalderadio.com\/",
 "country" : "US",
 "name" : "Alianza Internacional de Radio",
 "twitter" : "https:\/\/twitter.com\/AIRRADIONY"
 },
 */
class StationModel: NSObject {
    var id: String?
    var total_listeners: Int?
    var created_at: Date?
    var slug: String?
    var updatedAt: String?
    var country: String?
    var stream = [StreamModel]()
    var streamStr: String?
    
    init(json: (String, JSON)) {
        let dict = json.1.dictionaryValue
        self.id = dict["id"]?.rawString()
        //self.id = json["id"].string
        if let streamArr = dict["streams"] {
            let streamObj = streamArr[0]
            let streamStr = streamObj["stream"]
            self.streamStr = streamStr.rawString()
        }
   
        print(self.id)
        print(self.streamStr)
    }
    
}
