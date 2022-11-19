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
    public var interstitialAdUnitID = ""
    public var bannerAdUnitID = ""
    public var rewardAdUnitID = ""
    public var openAdUnitID = ""
    public var nativeAdUnitID = ""
}
