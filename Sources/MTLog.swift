//
//  MTLog.swift
//  AdmobManager
//
//  Created by Minh Tường on 07/10/2022.
//  Copyright © 2022 MTSOFT. All rights reserved.
//

import UIKit

func AdmobLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if AdmobManager.shared.configs.showLog {
        print("🐵 AdmobManager: \(items)", separator: separator, terminator: terminator)
    }
}
