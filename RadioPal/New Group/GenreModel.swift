//
//  GenreModel.swift
//  RadioPal
//
//  Created by Jami, Dheeraj on 9/20/17.
//  Copyright © 2017 Jami, Dheeraj. All rights reserved.
//

import Foundation
import SwiftyJSON

class GenreModel {
    var id: Int?
    var title: String?
    var description: String?
    var slug: String?
    var ancestry: String?
    
    init(json: JSON) {
        self.id = json["id"].int
        self.title = json["title"].string
        self.description = json["description"].string
        self.slug = json["slug"].string
        self.ancestry = json["ancestry"].string
    }
    
}
