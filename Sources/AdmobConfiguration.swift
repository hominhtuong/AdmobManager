//
//  AdmobConfiguration.swift
//  AdmobManager
//
//  Created by Minh Tường on 07/10/2022.
//  Copyright © 2022 MTSOFT. All rights reserved.
//

import UIKit

open class AdmobConfiguration {
    public init() {}
    
    public var showLog: Bool = false
    public var keyProversionStoraged: String = "kProversionStoraged"
    public var adUnit: AdUnits = AdUnits()
    public var removeADs_productID: String = ""
    public var frequencyCapping: Double = 0
    
    ///impressionPercentage for Interstitial. 
    ///default is 100% - alway show
    public var impressionPercentage: Int = 100
    
}

public class AdUnits {
    public var interstitialAdUnitID: String {
        get {
            #if DEBUG
            return DEBUG_interstitialAdUnitID
            #else
            return _interstitialAdUnitID
            #endif
        }
        set {
            _interstitialAdUnitID = newValue
        }
    }
    
    public var bannerAdUnitID: String {
        get {
            #if DEBUG
            return DEBUG_bannerAdUnitID
            #else
            return _bannerAdUnitID
            #endif
        }
        set {
            _bannerAdUnitID = newValue
        }
    }
    
    public var openAdUnitID: String {
        get {
            #if DEBUG
            return DEBUG_openAdUnitID
            #else
            return _openAdUnitID
            #endif
        }
        set {
            _openAdUnitID = newValue
        }
    }
    
    public var nativeAdUnitID: String {
        get {
            #if DEBUG
            return DEBUG_nativeAdUnitID
            #else
            return _nativeAdUnitID
            #endif
        }
        set {
            _nativeAdUnitID = newValue
        }
    }
    
    public var rewardAdUnitID: String {
        get {
            #if DEBUG
            return DEBUG_rewardAdUnitID
            #else
            return _rewardAdUnitID
            #endif
        }
        set {
            _rewardAdUnitID = newValue
        }
    }
    
    private let DEBUG_interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    private let DEBUG_bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    private let DEBUG_openAdUnitID = "ca-app-pub-3940256099942544/5662855259"
    private let DEBUG_nativeAdUnitID = "ca-app-pub-3940256099942544/3986624511"
    private let DEBUG_rewardAdUnitID = "ca-app-pub-3940256099942544/1712485313"
    


    
    private var _interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    private var _bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    private var _openAdUnitID = "ca-app-pub-3940256099942544/5662855259"
    private var _nativeAdUnitID = "ca-app-pub-3940256099942544/3986624511"
    private var _rewardAdUnitID = "ca-app-pub-3940256099942544/1712485313"
}
