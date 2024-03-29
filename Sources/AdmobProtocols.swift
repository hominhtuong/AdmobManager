//
//  AdmobProtocols.swift
//  AdmobManager
//
//  Created by Minh Tường on 07/10/2022.
//  Copyright © 2022 MTSOFT. All rights reserved.
//

import UIKit
import GoogleMobileAds

//MARK: - Banner Ads
public protocol AdmobManagerBannerDelegate {
    func adViewDidReceiveAd()
    func adViewDidFailToReceiveAd(error: Error)
    func adViewWillPresentScreen()
    func adViewWillDismissScreen()
    func adViewDidDismissScreen()
    func adViewInfo(adValue: GADAdValue, info: GADResponseInfo?)
}

//default implementation AdmobManagerBannerDelegate
public extension AdmobManagerBannerDelegate {
    func adViewDidReceiveAd() {}
    func adViewDidFailToReceiveAd(error: Error) {}
    func adViewWillPresentScreen() {}
    func adViewWillDismissScreen() {}
    func adViewDidDismissScreen() {}
    func adViewInfo(adValue: GADAdValue, info: GADResponseInfo?) {}
}

//MARK: - Interstitial Ads
public protocol AdmobManagerInterstitialDelegate {
    func interstitialDidFailToReceiveAd(error: Error)
    func interstitialDidPresentScreen()
    func interstitialDidDismissScreen()
    
    func interstitialInfo(adValue: GADAdValue, info: GADResponseInfo?)
}

//default implementation AdmobManagerInterstitialDelegate
public extension AdmobManagerInterstitialDelegate {
    func interstitialDidFailToReceiveAd(error: Error) {}
    func interstitialDidPresentScreen() {}
    func interstitialDidDismissScreen() {}
    func interstitialInfo(adValue: GADAdValue, info: GADResponseInfo?) {}
}

//MARK: - Native Ads
public protocol AdmobManagerNativeAdLoaderDelegate {
    func nativeDidFailToReceiveAd(error: Error)
    func nativeDidReceiveAd(_ adLoader: GADAdLoader,
                            didReceive nativeAd: GADNativeAd)
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader)
    func nativeAdInfo(adValue: GADAdValue, info: GADResponseInfo?)
}

//default implementation AdmobManagerNativeAdLoaderDelegate
public extension AdmobManagerNativeAdLoaderDelegate {
    func nativeDidFailToReceiveAd(error: Error) {}
    func nativeDidReceiveAd(_ adLoader: GADAdLoader,
                            didReceive nativeAd: GADNativeAd) {}
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {}
    func nativeAdInfo(adValue: GADAdValue, info: GADResponseInfo?) {}
}


//MARK: - Reward Ads
public protocol AdmobManagerRewardDelegate {
    func rewardAdDidFailToReceiveAd(error: Error)
    func rewardAdDidPresentScreen()
    func rewardAdDidDismissScreen(amount: Double)
    func rewardAdInfo(adValue: GADAdValue, info: GADResponseInfo?)
}

//default implementation AdmobManagerRewardDelegate
public extension AdmobManagerRewardDelegate {
    func rewardAdDidFailToReceiveAd(error: Error) {}
    func rewardAdDidPresentScreen() {}
    func rewardAdDidDismissScreen(amount: Double) {}
    func rewardAdInfo(adValue: GADAdValue, info: GADResponseInfo?) {}
}


//MARK: - Open Ads
public protocol AdmobManagerOpenAdsDelegate {
    func openAdDidFailToReceiveAd(error: Error)
    func openAdDidPresentScreen()
    func openAdDidDismissScreen()
    func openAdInfo(adValue: GADAdValue, info: GADResponseInfo?)
}

//default implementation AdmobManagerInterestialDelegate
public extension AdmobManagerOpenAdsDelegate {
    func openAdDidFailToReceiveAd(error: Error) {}
    func openAdDidPresentScreen() {}
    func openAdDidDismissScreen() {}
    func openAdInfo(adValue: GADAdValue, info: GADResponseInfo?) {}
}
