//
//  NativeAdView.swift
//  AdmobManager
//
//  Created by Minh Tường on 07/10/2022.
//  Copyright © 2022 MTSOFT. All rights reserved.
//

import MiTu
import GoogleMobileAds

//MARK: NativeAdView
public class NativeAdView: GADNativeAdView {
    //MARK: Variables
    public var style: NativeAdViewStyle = .banner
    public var configs: NativeConfigs = NativeConfigs() {
        didSet {
            self.backgroundColor = configs.backgroundColor
            self.actionButton.backgroundColor = configs.backgroundActionColor
            self.actionButton.setTitleColor(configs.textActionColor, for: .normal)
            self.adDetailLabel.textColor = configs.textColor
            self.adNameLabel.font = configs.adNameFont
            self.adDetailLabel.font = configs.adDetailFont
            self.actionButton.titleLabel?.font = configs.actionFont
        }
    }
    
    
    public let iconImageView = UIImageView()
    public let actionButton = UIButton()
    public let adDetailLabel = UILabel()
    public let adNameLabel = UILabel()
    public let adLabel = UILabel()
    
    
    //MARK: Init
    public init(style: NativeAdViewStyle) {
        super.init(frame: .zero)
        self.style = style
        self.setupView()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}

public extension NativeAdView {
    private func setupView() {
        self.backgroundColor = configs.backgroundColor
        self.layer.cornerRadius = 8
        
        iconImageView >>> self >>> {
            if self.style == .banner {
                $0.snp.makeConstraints {
                    $0.bottom.top.leading.equalToSuperview()
                    $0.width.equalTo(iconImageView.snp.height)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.bottom.equalToSuperview().offset(-16)
                    $0.leading.equalToSuperview().offset(16)
                    $0.height.width.equalTo(39)
                }
            }
            $0.clipsToBounds = true
            self.iconView = iconImageView
        }
        
        actionButton >>> self >>> {
            if self.style == .banner {
                $0.snp.makeConstraints {
                    $0.trailing.equalToSuperview().offset(-8)
                    $0.centerY.equalToSuperview()
                    $0.height.equalTo(39)
                    $0.width.equalTo(99)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.trailing.bottom.equalToSuperview().offset(-8)
                    $0.height.equalTo(39)
                    $0.width.equalTo(99)
                }
            }
            $0.layer.cornerRadius = 5
            $0.isHidden = true
            $0.backgroundColor = configs.backgroundActionColor
            $0.setTitleColor(configs.textActionColor, for: .normal)
            $0.titleLabel?.font = configs.actionFont
            $0.isUserInteractionEnabled = false
            self.callToActionView = actionButton
        }
        
        adDetailLabel >>> self >>> {
            if self.style == .banner {
                $0.snp.makeConstraints {
                    $0.bottom.equalToSuperview()
                    $0.top.equalTo(self.snp.centerY)
                    $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
                    $0.trailing.equalTo(actionButton.snp.leading).offset(-8)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.bottom.equalTo(iconImageView.snp.bottom)
                    $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
                    $0.trailing.equalTo(actionButton.snp.leading).offset(-8)
                }
            }
            $0.textColor = configs.textColor
            $0.font = configs.adDetailFont
            self.bodyView = adDetailLabel
        }
        
        adNameLabel >>> self >>> {
            if self.style == .banner {
                $0.snp.makeConstraints {
                    $0.bottom.equalTo(self.snp.centerY)
                    $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
                    $0.trailing.equalTo(actionButton.snp.leading).offset(-8)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.top.equalTo(iconImageView.snp.top)
                    $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
                    $0.trailing.equalTo(actionButton.snp.leading).offset(-8)
                }
            }
            
            $0.textColor = configs.textColor
            $0.font = configs.adNameFont
            self.headlineView = adNameLabel
        }
        
        if self.style == .native {
            let mediaView = GADMediaView()
            mediaView >>> self >>> {
                $0.snp.makeConstraints {
                    $0.top.equalToSuperview().offset(16)
                    $0.leading.equalTo(iconImageView.snp.leading)
                    $0.trailing.equalTo(actionButton.snp.trailing)
                    $0.bottom.equalTo(iconImageView.snp.top).offset(-16)
                }
                $0.backgroundColor = .clear
                self.mediaView = mediaView
            }
        }
        
        adLabel >>> self >>> {
            $0.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.width.height.equalTo(16)
            }
            $0.text = "Ad"
            $0.backgroundColor = UIColor.from("FFCC66")
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        }
    }
}

//MARK: NativeConfigs
public class NativeConfigs {
    public init() {}
    public var backgroundColor: UIColor = .white
    public var backgroundActionColor: UIColor = .yellow
    public var textActionColor: UIColor = .black
    public var textColor: UIColor = .black
    public var adNameFont: UIFont = UIFont.systemFont(ofSize: 17)
    public var adDetailFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var actionFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
}

//MARK: NativeAdViewStyle
public enum NativeAdViewStyle {
    case banner
    case native
}
