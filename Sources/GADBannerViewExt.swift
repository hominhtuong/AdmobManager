//
//  GADBannerViewExt.swift
//  AdmobManager
//
//  Created by Minh Tường on 07/10/2022.
//  Copyright © 2022 MTSOFT. All rights reserved.
//

import GoogleMobileAds

public extension GADBannerView {
    func load() {
        let request = GADRequest()
        self.load(request)
    }
}
