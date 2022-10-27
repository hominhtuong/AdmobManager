//
//  AdmobConfiguration.swift
//  AdmobManager
//
//  Created by Minh Tường on 07/10/2022.
//  Copyright © 2022 MTSOFT. All rights reserved.
//

import UIKit
import GoogleMobileAds

open class AdmobConfiguration {
    public init() {}
    
    public var keyProversionStoraged: String = "kProversionStoraged"
    public var keyInterstitialCounterStoraged: String = "keyInterstitialCounterStoraged"
    public var adUnit: AdUnits = AdUnits()
    public var testDevices: [String] = [] {
        didSet {
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = testDevices
        }
    }
    
    ///Show all log when request and show ads
    public var showLog: Bool = true
    
    ///default is 0 - alway request ads
    public var frequencyCapping: Double = 0
    
    ///default is 100% - alway show
    public var impressionPercentage: Int = 100
    
}
