//
//  NewList.swift
//  fierbase-amm
//
//  Created by Вика on 05.09.2021.
//

import Foundation
import Firebase

protocol DocumentSeralizable {
    init?(dictionary: [String: Any])
}

struct NewList {
    var name: String
    var phone: String
    var timeStamp: Double
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "phone": phone,
            "timeStamp": timeStamp
        ]
    }
}

extension NewList: DocumentSeralizable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
              let phone = dictionary["phone"] as? String,
              let timeStamp = dictionary["timeStamp"] as? Double
        else {return nil}
        self.init(name: name, phone: phone, timeStamp: timeStamp)
    }
}
