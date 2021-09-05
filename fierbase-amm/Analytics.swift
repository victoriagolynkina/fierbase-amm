//
//  Analytics.swift
//  fierbase-amm
//
//  Created by Вика on 24.08.2021.
//

import Foundation
import FirebaseAnalytics

class MyAnalytics {
   static let shared = MyAnalytics()
    
    func trackEvent(name: String) {
        Analytics.logEvent(name, parameters: [:])
    }
}
