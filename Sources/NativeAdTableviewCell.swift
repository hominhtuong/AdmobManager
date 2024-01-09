//
//  NativeAdTableviewCell.swift
//  AdmobManager
//
//  Created by Minh Tường on 07/10/2022.
//  Copyright © 2022 MTSOFT. All rights reserved.
//

import MiTu
import GoogleMobileAds

public class NativeAdTableviewCell : UITableViewCell {
    public var containerView: UIView!
    public let nativeAdView = NativeAdView(style: .banner)
    public var nativeAd: GADNativeAd!
    public var cellHeight: CGFloat = 79 {
        didSet {
            self.containerView.snp.makeConstraints {
                $0.height.equalTo(cellHeight)
            }
        }
    }
}

public extension NativeAdTableviewCell {
    func configsCell(nativeAd: GADNativeAd) {
        if containerView == nil {
            self.setupView()
        }
        
        self.nativeAd = nativeAd
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

public extension NativeAdTableviewCell {
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView = UIView()
        containerView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.centerY.equalToSuperview()
                $0.height.equalTo(cellHeight)
            }
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 8
        }
        
        self.nativeAdView >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.clipsToBounds = true
        }
    }
}
