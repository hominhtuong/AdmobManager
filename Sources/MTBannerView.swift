//
//  MTBannerView.swift
//  AdmobManager
//
//  Created by Minh Tường on 14/10/2022.
//  Copyright © 2022 MTSOFT. All rights reserved.
//

import GoogleMobileAds

//MARK: Auto add adUnitID and load request
public class MTBannerView: GADBannerView {
    public func configuration(adUnitID: String? = nil, rootViewController: UIViewController? = nil) {
        self.adUnitID = adUnitID ?? AdmobManager.shared.configs.adUnit.bannerAdUnitID
        if let viewcontroller = rootViewController {
            self.rootViewController = viewcontroller
        }
        
        self.load(GADRequest())
    }
}
