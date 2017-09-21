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
 ▿ {
 "total_listeners" : 81,
 "name" : "Arabesk FM",
 "updated_at" : "2017-09-18T02:29:00+02:00",
 "website" : "http:\/\/www.arabeskfm.biz",
 "twitter" : "fmarabesk",
 "facebook" : "https:\/\/www.facebook.com\/fmarabesk",
 "id" : 57401,
 "categories" : [
 {
 "id" : 18,
 "title" : "Classic Rock",
 "slug" : "classic-rock",
 "description" : "",
 "ancestry" : "2"
 }
 ],
 "streams" : [
 {
 "content_type" : "audio\/mpeg",
 "status" : 1,
 "listeners" : 81,
 "stream" : "http:\/\/yayin.arabeskfm.biz:8042",
 "bitrate" : 80
 }
 ],
 "created_at" : "2017-09-18T02:28:58+02:00",
 "image" : {
 "url" : "https:\/\/img.dirble.com\/station\/57401\/ce32587e-5df9-41b4-99b7-19f4b0c39d37.jpg",
 "thumb" : {
 "url" : "https:\/\/img.dirble.com\/station\/57401\/thumb_ce32587e-5df9-41b4-99b7-19f4b0c39d37.jpg"
 }
 },
 "slug" : "arabesk-fm-9c7d6baf-1b74-4d50-aded-83093a97746d",
 "country" : "TR"
 }
 
 
 
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
    var name: String?
    var total_listeners: Int?
    var created_at: Date?
    var slug: String?
    var updatedAt: String?
    var country: String?
    var stream = [StreamModel]()
    var url: String?
    var thumbUrl: String?

    init(json: JSON) {
        self.id = json["id"].string
        if let streamArray = json["streams"].array {
            for stream in streamArray {
                let streamObj = StreamModel(json: stream)
                self.stream.append(streamObj)
            }
        }
        if let imageDict = json["image"].dictionary {
            self.url = imageDict["url"]?.string
            if let thumbDict = imageDict["thumb"]?.dictionary {
                self.thumbUrl = thumbDict["url"]?.string
            }
        }

    }
    
}
