//
//  CountryModel.swift
//  RadioPal
//
//  Created by Jami, Dheeraj on 9/20/17.
//  Copyright © 2017 Jami, Dheeraj. All rights reserved.
//

import UIKit
import SwiftyJSON

class CountryModel: NSObject {
    var name: String?
    var code: String?
    
    init(json: JSON) {
        self.name = json["name"].string
        self.code = json["code"].string
    }
}
