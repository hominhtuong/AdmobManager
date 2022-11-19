//
//  AdUnits.swift
//  AdmobManager
//
//  Created by Minh Tường on 14/10/2022.
//

public class AdUnits {
    //MARK: Initial
    public init() {}
    public init(bannerAdID: String? = nil, interstitialAdID: String? = nil, openAdID: String? = nil, nativeAdID: String? = nil, rewardAdID: String? = nil) {
        if let bannerAdID = bannerAdID {
            self.bannerAdUnitID = bannerAdID
        }
        
        if let interstitialAdID = interstitialAdID {
            self.interstitialAdUnitID = interstitialAdID
        }
        
        if let openAdID = openAdID {
            self.openAdUnitID = openAdID
        }
        
        if let nativeAdID = nativeAdID {
            self.nativeAdUnitID = nativeAdID
        }
        
        if let rewardAdID = rewardAdID {
            self.rewardAdUnitID = rewardAdID
        }
    }
    
    //MARK: Variables
    public var interstitialAdUnitID: String {
        get {
            if AdmobManager.shared.configs.enviroment == .DEBUG {
                return DEBUG_interstitialAdUnitID
            } else {
                return _interstitialAdUnitID
            }
        }
        set {
            _interstitialAdUnitID = newValue
        }
    }
    
    public var bannerAdUnitID: String {
        get {
            if AdmobManager.shared.configs.enviroment == .DEBUG {
                return DEBUG_bannerAdUnitID
            } else {
                return _bannerAdUnitID
            }
        }
        set {
            _bannerAdUnitID = newValue
        }
    }
    
    public var openAdUnitID: String {
        get {
            if AdmobManager.shared.configs.enviroment == .DEBUG {
                return DEBUG_openAdUnitID
            } else {
                return _openAdUnitID
            }
        }
        set {
            _openAdUnitID = newValue
        }
    }
    
    public var nativeAdUnitID: String {
        get {
            if AdmobManager.shared.configs.enviroment == .DEBUG {
                return DEBUG_nativeAdUnitID
            } else {
                return _nativeAdUnitID
            }
        }
        set {
            _nativeAdUnitID = newValue
        }
    }
    
    public var rewardAdUnitID: String {
        get {
            if AdmobManager.shared.configs.enviroment == .DEBUG {
                return DEBUG_rewardAdUnitID
            } else {
                return _rewardAdUnitID
            }
        }
        set {
            _rewardAdUnitID = newValue
        }
    }
    
    ///DEBUG KEYS
    private let DEBUG_interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    private let DEBUG_bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    private let DEBUG_openAdUnitID = "ca-app-pub-3940256099942544/5662855259"
    private let DEBUG_nativeAdUnitID = "ca-app-pub-3940256099942544/3986624511"
    private let DEBUG_rewardAdUnitID = "ca-app-pub-3940256099942544/1712485313"

    ///RELEASE KEYS
    private var _interstitialAdUnitID = ""
    private var _bannerAdUnitID = ""
    private var _openAdUnitID = ""
    private var _nativeAdUnitID = ""
    private var _rewardAdUnitID = ""
}
