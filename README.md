# AdmobManager

[![Version](https://img.shields.io/cocoapods/v/AdmobManager.svg?style=flat)](https://cocoapods.org/pods/AdmobManager)
[![License](https://img.shields.io/cocoapods/l/AdmobManager.svg?style=flat)](https://cocoapods.org/pods/AdmobManager)
[![Platform](https://img.shields.io/cocoapods/p/AdmobManager.svg?style=flat)](https://cocoapods.org/pods/AdmobManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift
import AdmobManager

        let adUnits = AdUnits(
                                bannerAdID: "ca-app-pub...",
                                interstitialAdID: "ca-app-pub...",
                                openAdIDs: ["type1", "type2", "type3"],
                                rewardAdID: "ca-app-pub...")
        
        AdmobManager.shared.configs.adUnit = adUnits
        AdmobManager.shared.configs.showLog = true
        AdmobManager.shared.configs.frequencyCapping = 30
        AdmobManager.shared.configs.impressionPercentage = 100
        AdmobManager.shared.loadOpenAd()
```


## Requirements

## Installation

MTAdmob is available through [CocoaPods](https://cocoapods.org/pods/AdmobManager). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AdmobManager'
```

## Author

hominhtuong, minhtuong2502@gmail.com

## License

AdmobManager is available under the MIT license. See the LICENSE file for more info.
