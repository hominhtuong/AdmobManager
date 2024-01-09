//
//  GDPRManager.swift
//  AdmobManager
//
//  Created by Hồ Minh Tường on 09/01/2024.
//

import Foundation
import UserMessagingPlatform
import MiTu
import AppTrackingTransparency
import AdSupport

public class GDPRManager : NSObject
{
    public static let shared = GDPRManager()
    
    public var getVendorConsents: String
    {
        get {
            return UserDefaults.standard.string(forKey: "IABTCF_VendorConsents") ?? ""
        }
    }
    public var getPurposeConsents: String
    {
        get {
            return UserDefaults.standard.string(forKey: "IABTCF_PurposeConsents") ?? ""
        }
    }
    public var getAddtlConsent: String
    {
        get {
            return UserDefaults.standard.string(forKey: "IABTCF_AddtlConsent") ?? ""
        }
    }
    
    public var isGDPR: Bool
    {
        get {
            let settings = UserDefaults.standard
            let gdpr     = settings.integer(forKey: "IABTCF_gdprApplies")
            return gdpr == 1
        }
    }
    
    // Check if a binary string has a "1" at position "index" (1-based)
    public func hasAttribute(input: String, index: Int) -> Bool
    {
        return input.count >= index && String(Array(input)[index-1]) == "1"
    }
    
    // Check if consent is given for a list of purposes
    public func hasConsentFor(_ purposes: [Int], _ purposeConsent: String) -> Bool
    {
        return purposes.allSatisfy { i in hasAttribute(input: purposeConsent, index: i) }
    }
    
    // Check if a vendor either has consent or legitimate interest for a list of purposes
    public func hasConsentOrLegitimateInterestFor(_ purposes: [Int], _ purposeConsent: String, _ purposeLI: String) -> Bool
    {
        return purposes.allSatisfy
        { i in
            hasAttribute(input: purposeLI, index: i) ||
            hasAttribute(input: purposeConsent, index: i)
        }
    }
    
    public var canShowAds: Bool
    {
        get {
            let settings = UserDefaults.standard
            let purposeConsent = settings.string(forKey: "IABTCF_PurposeConsents") ?? ""
            let purposeLI      = settings.string(forKey: "IABTCF_PurposeLegitimateInterests") ?? ""
            
            return hasConsentFor([1], purposeConsent) &&
            hasConsentOrLegitimateInterestFor([2,7,9,10], purposeConsent, purposeLI)
        }
        
    }
    
    public var canShowPersonalizedAds: Bool
    {
        get {
            let settings = UserDefaults.standard
            let purposeConsent = settings.string(forKey: "IABTCF_PurposeConsents") ?? ""
            let purposeLI      = settings.string(forKey: "IABTCF_PurposeLegitimateInterests") ?? ""
            
            return hasConsentFor([1,3,4], purposeConsent) &&
            hasConsentOrLegitimateInterestFor([2,7,9,10], purposeConsent, purposeLI)
        }
    }
    
    public var canRequestAds: Bool
    {
        return UMPConsentInformation.sharedInstance.canRequestAds
    }
    
    public var isPrivacyOptionsRequired: Bool {
        return UMPConsentInformation.sharedInstance.privacyOptionsRequirementStatus == .required
    }
    
    public func isVendorAutorized(vendorID: Int) -> Bool
    {
        let settings      = UserDefaults.standard
        let vendorConsent = settings.string(forKey: "IABTCF_VendorConsents") ?? ""
        
        return hasAttribute(input:vendorConsent, index:vendorID)
    }
    
    public func isExternalAutorized(externalID: Int) -> Bool
    {
        let strId        = String(externalID)
        let settings     = UserDefaults.standard
        let addtlConsent = settings.string(forKey: "IABTCF_AddtlConsent") ?? ""
        
        return addtlConsent.contains(strId)
    }
    
    public func deleteOutdatedTCString() -> Bool
    {
        let settings = UserDefaults.standard
        let tcString      = settings.string(forKey: "IABTCF_TCString") ?? "AAAAAAA";
        let base64        = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        var dateSubstring = "";
        if( tcString.count >= 7 )
        {
            let start     = tcString.index(tcString.startIndex, offsetBy: 1)
            let end       = tcString.index(tcString.startIndex, offsetBy: 7)
            let range     = start..<end
            dateSubstring = String(tcString[range]);
        }
        
        var timestamp:Int64 = 0;
        for c in dateSubstring
        {
            let value = Int64(indexOf(base64, c));
            timestamp = timestamp * 64 + value;
        }
        
        // timestamp is given is deci-seconds, convert to milliseconds
        timestamp *= 100;
        
        // compare with current timestamp to get age in days
        let now     = Date().millisecondsSince1970;
        let daysAgo = (now - timestamp) / (1000*60*60*24);
        
        // logging debug infos
        print("GDPRHelper:: deleteOutdatedTCString now = \(now) - timestamp = \(timestamp) - daysAgo = \(daysAgo)")
        
        // delete TC string if age is over a year
        if( daysAgo > 365 )
        {
            settings.set("", forKey: "IABTCF_TCString")
            return true;
        }
        
        return false;
    }
    
    private func indexOf( _ str: String, _ c: Character ) -> Int
    {
        if let firstIndex = str.firstIndex(of: c) {
            let index = str.distance(from: str.startIndex, to: firstIndex)
            return index;
        }
        return -1;
    }
}

public extension GDPRManager {
    func requestTracking(from topVC: UIViewController? = nil, testDeviceIdentifiers: [String] = []) async -> Error? {
        await withCheckedContinuation { continuation in
            Task {
                let consent = await gatherConsent(from: topVC, testDeviceIdentifiers: testDeviceIdentifiers)
                if #available(iOS 14, *) {
                    let idfa = await requestIDFA()
                    AdmobLog("IDFA: \(idfa)")
                }
                continuation.resume(returning: consent)
            }
        }
        
    }
    
    func gatherConsent(from topVC: UIViewController? = nil, testDeviceIdentifiers: [String] = []) async -> Error? {
        await withCheckedContinuation { continuation in
            
            if (isGDPR && !canShowAds) {
                UMPConsentInformation.sharedInstance.reset()
            }
            
            let parameters = UMPRequestParameters()
            parameters.tagForUnderAgeOfConsent = false
            
            if testDeviceIdentifiers.count > 0 {
                let debugSettings = UMPDebugSettings()
                debugSettings.testDeviceIdentifiers = testDeviceIdentifiers
                debugSettings.geography = UMPDebugGeography.EEA
                parameters.debugSettings = debugSettings
            }
            
            UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) { requestConsentError in
                if let error = requestConsentError {
                    return continuation.resume(returning: error)
                }
                
                guard let topViewController = topVC ?? topViewController else {
                    return continuation.resume(returning: MTError(title: "Cannot get top view controller", description: "", code: -1))
                }
                
                UMPConsentForm.loadAndPresentIfRequired(from: topViewController) {
                    loadAndPresentError in
                    
                    if let error = loadAndPresentError {
                        return continuation.resume(returning: error)
                    }
                    
                    continuation.resume(returning: nil)
                }
            }
        }
        
    }
    
    @available(iOS 14, *)
    func requestIDFA() async -> Bool {
        await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
