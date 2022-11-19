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
            self._bannerAdUnitID = bannerAdID
        }
        
        if let interstitialAdID = interstitialAdID {
            self._interstitialAdUnitID = interstitialAdID
        }
        
        if let openAdID = openAdID {
            self._openAdUnitID = openAdID
        }
        
        if let nativeAdID = nativeAdID {
            self._nativeAdUnitID = nativeAdID
        }
        
        if let rewardAdID = rewardAdID {
            self._rewardAdUnitID = rewardAdID
        }
    }
    
    //MARK: Variables
    private var _interstitialAdUnitID = ""
    private var _bannerAdUnitID = ""
    private var _openAdUnitID = ""
    private var _nativeAdUnitID = ""
    private var _rewardAdUnitID = ""
}
