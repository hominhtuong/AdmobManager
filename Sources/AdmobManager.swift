//
//  AdmobManager.swift
//  AdmobManager
//
//  Created by Minh Tường on 07/10/2022.
//  Copyright © 2022 MTSOFT. All rights reserved.
//

import GoogleMobileAds
import MTSDK

public class AdmobManager: NSObject {
    public static let shared = AdmobManager()
    
    //public variables
    public var configs: AdmobConfiguration = AdmobConfiguration()
    public var bannerDelegate: AdmobManagerBannerDelegate?
    public var interstitialDelegate: AdmobManagerInterstitialDelegate?
    public var rewardDelegate: AdmobManagerRewardDelegate?
    public var openAdsDelegate: AdmobManagerOpenAdsDelegate?
    public var adLoaderDelegate: AdmobManagerNativeAdLoaderDelegate?
    
    public var interstitialCounter: Int {
        get {
            return UserDefaults.standard.integer(forKey: configs.keyInterstitialCounterStoraged)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: configs.keyInterstitialCounterStoraged)
            UserDefaults.standard.synchronize()
        }
    }
    public var isProversion: Bool {
        get {
            return UserDefaults.standard.bool(forKey: configs.keyProversionStoraged)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: configs.keyProversionStoraged)
            UserDefaults.standard.synchronize()
        }
    }
    
    //private variables
    private var appOpenAd: GADAppOpenAd?
    private var completionShowOpenAd: (() -> Void)?
    private var openAdHasBeenShow: Bool = false
    private var openAdLoading: Bool = false
    
    private var interstitial: GADInterstitialAd?
    private var lastDate: TimeInterval = 0
    private var interstitialHasBeenShow: Bool = false
    private var interstitialLoading: Bool = false
    private var completionShowInterstitial: (() -> Void)?
    
    private var adLoader: GADAdLoader!
    
    private var rewardedAd: GADRewardedAd?
    private var completionRewardAds: ((Double) -> Void)?
    private var rewardAdHasBeenShow: Bool = false
    private var rewardAdLoading: Bool = false
}

//MARK: Configs
public extension AdmobManager {
    func start(completionHandler: (GADInitializationCompletionHandler)? = nil) {
        GADMobileAds.sharedInstance().start(completionHandler: completionHandler)
    }
    
    func addTestDevices(_ deviceIDs: [String]) {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = deviceIDs
    }
    
    func setMaxAdContentRating(_ rating: GADMaxAdContentRating) {
        GADMobileAds.sharedInstance().requestConfiguration.maxAdContentRating = rating
    }
}

//MARK: Interstitial
public extension AdmobManager {
    func loadInterstitial() {
        if AdmobManager.shared.isProversion {
            AdmobLog("is proversion, return")
            return
        }
        if AdmobManager.shared.interstitial != nil {
            AdmobLog("interstitial is avaiable to show, return")
            return
        }
        if AdmobManager.shared.interstitialLoading {
            AdmobLog("interstitial is loading, return")
            return
        }
        AdmobManager.shared.interstitialLoading = true
        AdmobLog("requesting interstitial.....")
        GADInterstitialAd.load(withAdUnitID: configs.adUnit.interstitialAdUnitID, request: GADRequest(), completionHandler: { [self] ad, error in
            AdmobManager.shared.interstitialLoading = false
            if let error = error {
                AdmobLog("Failed to load interstitial ad with error: \(error.localizedDescription)")
                AdmobManager.shared.interstitialDelegate?.interstitialDidFailToReceiveAd(error: error)
                return
            }
            AdmobManager.shared.interstitial = ad
            AdmobManager.shared.interstitial?.fullScreenContentDelegate = self
            AdmobManager.shared.interstitialHasBeenShow = false
        })
    }
    
    func showInterstitial(percent: Int? = nil, frequencyCapping: Double? = nil, completion: (() -> Void)? = nil) {
        if AdmobManager.shared.interstitialHasBeenShow || AdmobManager.shared.openAdHasBeenShow {
            if let completion = completion {
                completion()
            }
            AdmobLog("Ads is displaying, return")
            return
        }
        let impressionPercentage = percent ?? AdmobManager.shared.configs.impressionPercentage
        let frequencyCapping = frequencyCapping ?? AdmobManager.shared.configs.frequencyCapping
        
        if AdmobManager.shared.isProversion {
            if let completion = completion {
                completion()
            }
            AdmobLog("is proversion, return")
            return
        }
        let date = Date().timeIntervalSince1970
        let diff = date - AdmobManager.shared.lastDate
        if diff < frequencyCapping {
            AdmobLog("moi vua show ads xong: \(diff)")
            if let completion = completion {
                completion()
            }
            return
        }
        let randomPercent = Int.random(in: 0...99)
        AdmobLog("config: \(impressionPercentage), random: \(randomPercent)")
        if randomPercent < impressionPercentage {
            if let ad = AdmobManager.shared.interstitial {
                if let topViewController = topViewController {
                    AdmobLog("showing interstitial....")
                    AdmobManager.shared.completionShowInterstitial = completion
                    AdmobManager.shared.interstitialHasBeenShow = true
                    ad.present(fromRootViewController: topViewController)
                    AdmobManager.shared.interstitialCounter += 1
                } else {
                    if let completion = completion {
                        completion()
                    }
                    AdmobLog("cannot get top viewcontroller")
                }
            } else {
                AdmobLog("interstitial is nil")
                if let completion = completion {
                    completion()
                }
                AdmobManager.shared.loadInterstitial()
            }
        } else {
            AdmobLog("Hên quá, ads sẽ không show")
            if let completion = completion {
                completion()
            }
        }
    }
}

//MARK: Reward Ads
public extension AdmobManager {
    func loadRewardAds() {
        if AdmobManager.shared.isProversion {
            AdmobLog("is proversion, return")
            return
        }
        if AdmobManager.shared.rewardedAd != nil {
            AdmobLog("rewardedAd is avaiable to show, return")
            return
        }
        if AdmobManager.shared.rewardAdLoading {
            AdmobLog("rewardedAd is loading, return")
            return
        }
        AdmobManager.shared.rewardAdLoading = true
        AdmobLog("requesting rewardedAd.....")
        GADRewardedAd.load(
            withAdUnitID: configs.adUnit.rewardAdUnitID,
            request: GADRequest(), completionHandler: { [self] ad, error in
                
                AdmobManager.shared.rewardAdLoading = false
                if let error = error {
                    AdmobLog("Failed to load rewardedAd ad with error: \(error.localizedDescription)")
                    AdmobManager.shared.rewardDelegate?.rewardAdDidFailToReceiveAd(error: error)
                    return
                }
                AdmobManager.shared.rewardedAd = ad
                AdmobManager.shared.rewardedAd?.fullScreenContentDelegate = self
                AdmobManager.shared.rewardAdHasBeenShow = false
        })
    }
    
    func showRewardAd(completion: ((Double) -> Void)? = nil) {
        if AdmobManager.shared.isProversion {
            if let completion = completion {
                completion(0)
            }
            AdmobLog("is proversion, return")
            return
        }
        if let ad = AdmobManager.shared.rewardedAd {
            if let topViewController = topViewController {
                AdmobManager.shared.completionRewardAds = completion
                AdmobManager.shared.rewardAdHasBeenShow = true
                ad.present(fromRootViewController: topViewController, userDidEarnRewardHandler: {
                    let reward = ad.adReward
                    if let completion = completion {
                        completion(reward.amount.doubleValue)
                        AdmobManager.shared.completionRewardAds = nil
                    }
                })
                AdmobLog("showing reward ads....")
            }
        } else {
            AdmobLog("reward ads is nil, requesting new reward ads")
            AdmobManager.shared.loadRewardAds()
            if let completion = completion {
                completion(0)
            }
        }
    }
}

//MARK: Open Ads
public extension AdmobManager {
    func loadOpenAd() {
        if AdmobManager.shared.isProversion {
            AdmobLog("is proversion, return")
            return
        }
        if AdmobManager.shared.appOpenAd != nil {
            AdmobLog("openads is avaiable to show, return")
            return
        }
        AdmobLog("request open ads")
        AdmobManager.shared.openAdLoading = true
        GADAppOpenAd.load(withAdUnitID: AdmobManager.shared.configs.adUnit.openAdUnitID, request: GADRequest(), orientation: .portrait, completionHandler: { appOpenAd, error in
            AdmobManager.shared.openAdLoading = false
            if let error = error {
                AdmobLog("Failed to load app open ad: \(error.localizedDescription)")
                AdmobManager.shared.openAdsDelegate?.openAdDidFailToReceiveAd(error: error)
                return
            }
            self.appOpenAd = appOpenAd
            self.appOpenAd?.fullScreenContentDelegate = self
            AdmobManager.shared.openAdHasBeenShow = false
        })
    }
    
    func showOpenAd(completion: (() -> Void)? = nil) {
        if AdmobManager.shared.interstitialHasBeenShow || AdmobManager.shared.openAdHasBeenShow {
            if let completion = completion {
                completion()
            }
            AdmobLog("Ads is displaying, return")
            return
        }
        
        if AdmobManager.shared.isProversion {
            if let completion = completion {
                completion()
            }
            AdmobLog("is proversion, return")
            return
        }
        if let ad = AdmobManager.shared.appOpenAd {
            if let topViewController = topViewController {
                AdmobManager.shared.completionShowOpenAd = completion
                AdmobManager.shared.openAdHasBeenShow = true
                ad.present(fromRootViewController: topViewController)
                AdmobLog("showing open ads....")
            }
        } else {
            AdmobLog("open ads is nil, requesting new open ads")
            AdmobManager.shared.loadOpenAd()
            if let completion = completion {
                completion()
            }
        }
    }
}


//MARK: Banner View
public extension AdmobManager {
    func bannerView() -> GADBannerView {
        let banner = GADBannerView()
        banner.adUnitID = AdmobManager.shared.configs.adUnit.bannerAdUnitID
        banner.delegate = self
        banner.load(GADRequest())
        return banner
    }
    
    func bannerView(rootVC viewcontroller: UIViewController) -> GADBannerView {
        let banner = GADBannerView()
        banner.adUnitID = AdmobManager.shared.configs.adUnit.bannerAdUnitID
        banner.rootViewController = viewcontroller
        banner.delegate = self
        banner.load(GADRequest())
        return banner
    }
}

//MARK: Native Ads
public extension AdmobManager {
    func loadNativeAd(root viewcontroller: UIViewController) {
        adLoader = GADAdLoader(adUnitID: configs.adUnit.nativeAdUnitID, rootViewController: viewcontroller,
                        adTypes: [.native],
                        options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func loadMultiNativeAds(root viewcontroller: UIViewController, numberOfAds: Int = 5) {
        if AdmobManager.shared.isProversion {
            AdmobLog("is proversion, return")
            return
        }
        
        AdmobLog("load native ads")
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = numberOfAds
        adLoader = GADAdLoader(adUnitID: configs.adUnit.nativeAdUnitID,
                               rootViewController: viewcontroller,
                               adTypes: [.native],
                               options: [multipleAdsOptions])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
}

//MARK: - GADBannerViewDelegate
extension AdmobManager: GADBannerViewDelegate {
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        AdmobLog("bannerViewDidReceiveAd")
        AdmobManager.shared.bannerDelegate?.adViewDidReceiveAd()
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        AdmobLog("didFailToReceiveAdWithError: \(error.localizedDescription)")
        AdmobManager.shared.bannerDelegate?.adViewDidFailToReceiveAd(error: error)
    }
    
    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        AdmobLog("bannerViewWillPresentScreen")
        AdmobManager.shared.bannerDelegate?.adViewWillPresentScreen()
    }
    
    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        AdmobLog("bannerViewWillDismissScreen")
        AdmobManager.shared.bannerDelegate?.adViewWillDismissScreen()
    }
    
    public func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        AdmobLog("bannerViewDidDismissScreen")
        AdmobManager.shared.bannerDelegate?.adViewDidDismissScreen()
    }
    
}

//MARK: - GADFullScreenContentDelegate
extension AdmobManager: GADFullScreenContentDelegate {
    
    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
        if AdmobManager.shared.openAdHasBeenShow {
            AdmobLog("open ads Will Present Full Screen Content")
            AdmobManager.shared.openAdsDelegate?.openAdDidPresentScreen()
        }
        
        if AdmobManager.shared.interstitialHasBeenShow {
            AdmobLog("interstitial Will Present Full Screen Content")
            AdmobManager.shared.interstitialDelegate?.interstitialDidPresentScreen()
        }
        
        if AdmobManager.shared.rewardAdHasBeenShow {
            AdmobLog("reward ads Will Present Full Screen Content")
            AdmobManager.shared.rewardDelegate?.rewardAdDidPresentScreen()
        }
    }
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        AdmobLog("did Fail To Present Full Screen Content With Error: \(error.localizedDescription)")
        
        if AdmobManager.shared.openAdHasBeenShow {
            AdmobManager.shared.appOpenAd = nil
            AdmobManager.shared.openAdHasBeenShow = false
            if let completion = AdmobManager.shared.completionShowOpenAd {
                completion()
                AdmobLog("dismiss open ads completion")
                AdmobManager.shared.completionShowOpenAd = nil
            }
            
            openAdsDelegate?.openAdDidDismissScreen()
        }
        
        if AdmobManager.shared.interstitialHasBeenShow {
            AdmobManager.shared.lastDate = Date().timeIntervalSince1970
            AdmobManager.shared.interstitial = nil
            AdmobManager.shared.loadInterstitial()
            AdmobManager.shared.interstitialHasBeenShow = false
            if let completion =  AdmobManager.shared.completionShowInterstitial {
                completion()
                AdmobLog("dismiss interstitial completion")
                AdmobManager.shared.completionShowInterstitial = nil
            }
            
            interstitialDelegate?.interstitialDidDismissScreen()
        }
        
        if AdmobManager.shared.rewardAdHasBeenShow {
            AdmobManager.shared.rewardedAd = nil
            AdmobManager.shared.loadRewardAds()
            AdmobManager.shared.rewardAdHasBeenShow = false
            rewardDelegate?.rewardAdDidDismissScreen()
        }
    }

    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        AdmobLog("adDidDismissFullScreenContent")
        
        if AdmobManager.shared.openAdHasBeenShow {
            AdmobManager.shared.appOpenAd = nil
            AdmobManager.shared.openAdHasBeenShow = false
            if let completion = AdmobManager.shared.completionShowOpenAd {
                completion()
                AdmobLog("dismiss open ads completion")
                AdmobManager.shared.completionShowOpenAd = nil
            }
            
            openAdsDelegate?.openAdDidDismissScreen()
        }
        
        if AdmobManager.shared.interstitialHasBeenShow {
            AdmobManager.shared.lastDate = Date().timeIntervalSince1970
            AdmobManager.shared.interstitial = nil
            AdmobManager.shared.loadInterstitial()
            AdmobManager.shared.interstitialHasBeenShow = false
            if let completion =  AdmobManager.shared.completionShowInterstitial {
                completion()
                AdmobLog("dismiss interstitial completion")
                AdmobManager.shared.completionShowInterstitial = nil
            }
            
            interstitialDelegate?.interstitialDidDismissScreen()
        }
    }
}

extension AdmobManager: GADNativeAdLoaderDelegate {
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        AdmobLog("didFailToReceiveAdWithError: \(error.localizedDescription)")
        adLoaderDelegate?.nativeDidFailToReceiveAd(error: error)
    }
    
    public func adLoader(_ adLoader: GADAdLoader,
                    didReceive nativeAd: GADNativeAd) {
        AdmobLog("adLoader.adUnitID + \(nativeAd.responseInfo)")
        adLoaderDelegate?.nativeDidReceiveAd(adLoader, didReceive: nativeAd)
    }

    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        AdmobLog("adLoaderDidFinishLoading")
        adLoaderDelegate?.adLoaderDidFinishLoading(adLoader)
    }
    
}
