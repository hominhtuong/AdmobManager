//
//  ViewController.swift
//  Example
//
//  Created by Minh Tường on 07/10/2022.
//

import AdmobManager
import MTSDK
import GoogleMobileAds

class ViewController: UIViewController {
    
    //Variables
    private let kEnterBackground = "kEnterBackground"
    let nativeAdView = NativeAdView(style: .native)
}

extension ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        AdmobManager.shared.loadInterstitial()
        
        AdmobManager.shared.interstitialDelegate = self
        AdmobManager.shared.openAdsDelegate = self
        AdmobManager.shared.bannerDelegate = self
        AdmobManager.shared.adLoaderDelegate = self
        AdmobManager.shared.rewardDelegate = self
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @objc func applicationDidBecomeActive() {
        if UserDefaults.standard.bool(forKey: kEnterBackground) {
            AdmobManager.shared.showOpenAd {
                print("show open ads thanh cong")
            }
            UserDefaults.standard.set(false, forKey: kEnterBackground)
            UserDefaults.standard.synchronize()

        }
    }
    
    @objc func applicationWillResignActive() {
        AdmobManager.shared.loadOpenAd()
    }
    
    @objc func applicationDidEnterBackground() {
        UserDefaults.standard.set(true, forKey: kEnterBackground)
        UserDefaults.standard.synchronize()
    }
}

extension ViewController {
    private func setupView() {
        
        let nativeConfig = NativeConfigs()
        nativeConfig.textActionColor = .red
        
        nativeAdView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(topSafe)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.snp.centerY).offset(-16)
            }
            $0.backgroundColor = .purple.withAlphaComponent(0.5)
            $0.configs = nativeConfig
        }
        
        let interstitialButton = UIButton()
        interstitialButton >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(view.snp.centerY).offset(16)
                $0.trailing.equalTo(view.snp.centerX).offset(-32)
                $0.height.equalTo(50)
                $0.width.equalTo(100)
            }
            $0.setTitle("Interstitial", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .random
            $0.handle {
                AdmobManager.shared.showInterstitial {
                    print("show interstitial thanh cong")
                }
            }
        }
        
        let openAdButton = UIButton()
        openAdButton >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(view.snp.centerY).offset(16)
                $0.leading.equalTo(view.snp.centerX).offset(32)
                $0.height.equalTo(50)
                $0.width.equalTo(100)
            }
            $0.setTitle("Open Ads", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .random
            $0.handle {
                AdmobManager.shared.showOpenAd {
                    print("show OpenAd thanh cong")
                }
            }
        }
        
        let nativeAdButton = UIButton()
        nativeAdButton >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(interstitialButton.snp.bottom).offset(16)
                $0.trailing.equalTo(interstitialButton)
                $0.height.equalTo(50)
                $0.width.equalTo(100)
            }
            $0.setTitle("Native Ads", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .random
            $0.handle {
                AdmobManager.shared.loadNativeAd(root: self)
            }
        }
        
        let rewardAdButton = UIButton()
        rewardAdButton >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(interstitialButton.snp.bottom).offset(16)
                $0.leading.equalTo(openAdButton)
                $0.height.equalTo(50)
                $0.width.equalTo(100)
            }
            $0.setTitle("Reward Ads", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .random
            $0.handle {
                if AdmobManager.shared.rewardAdAvailable {
                    AdmobManager.shared.showRewardAd { value in
                        print("show Reward Ad thanh cong, coin: \(value)")
                    }
                } else {
                    print("khong co ads, di load ad moi")
                    AdmobManager.shared.loadRewardAds()
                }
                
            }
        }
        
        let banner = MTBannerView()
        banner >>> view >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(botSafe)
                $0.height.equalTo(50)
            }
            $0.configuration(rootViewController: self)
        }
    }
    
    func displayNativeAd(_ nativeAd: GADNativeAd) {
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

        
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
          nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        nativeAdView.nativeAd = nativeAd
    }
}

//MARK: AdmobManagerNativeAdLoaderDelegate
extension ViewController: AdmobManagerNativeAdLoaderDelegate {
    func nativeDidFailToReceiveAd(error: Error) {
        print("nativeDidFailToReceiveAd: \(error)")
    }
    
    func nativeDidReceiveAd(_ adLoader: GADAdLoader,
                            didReceive nativeAd: GADNativeAd) {
        print("nativeDidReceiveAd")
        displayNativeAd(nativeAd)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("adLoaderDidFinishLoading")
    }
}

//MARK: AdmobManagerInterstitialDelegate
extension ViewController: AdmobManagerInterstitialDelegate {
    func interstitialDidFailToReceiveAd(error: Error) {
        print("interstitialDidFailToReceiveAd: \(error)")
    }
    
     func interstitialDidPresentScreen() {
        print("interstitialDidPresentScreen")
    }
    
    func interstitialDidDismissScreen() {
        print("interstitialDidDismissScreen")
    }
}

//MARK: AdmobManagerOpenAdsDelegate
extension ViewController: AdmobManagerOpenAdsDelegate {
    func openAdDidFailToReceiveAd(error: Error) {
        print("openAdsDidFailToReceiveAd: \(error.localizedDescription)")
    }
    
    func openAdDidPresentScreen() {
        print("openAdsDidPresentScreen")
    }
    
    func openAdDidDismissScreen() {
        print("openAdsDidDismissScreen")
    }
}

//MARK: AdmobManagerRewardDelegate
extension ViewController: AdmobManagerRewardDelegate {
    func rewardAdDidFailToReceiveAd(error: Error) {
        print("rewardAdDidFailToReceiveAd: \(error.localizedDescription)")
    }
    
    func rewardAdDidPresentScreen() {
        print("rewardAdDidPresentScreen")
    }
    
    func rewardAdDidDismissScreen() {
        print("rewardAdDidDismissScreen")
    }
}

//MARK: AdmobManagerBannerDelegate
extension ViewController: AdmobManagerBannerDelegate {
    func adViewDidReceiveAd() {
        print("adViewDidReceiveAd")
    }
    
    func adViewDidFailToReceiveAd(error: Error) {
        print("adViewDidFailToReceiveAd: \(error.localizedDescription)")
    }
    
    func adViewWillPresentScreen() {
        print("adViewWillPresentScreen")
    }
    
    func adViewWillDismissScreen() {
        print("adViewWillDismissScreen")
    }
    
    func adViewDidDismissScreen() {
        print("adViewDidDismissScreen")
    }
    
}

