//
//  Device.swift
//  Restaurant
//
//  Created by Luiz on 7/17/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class Device {
    static let singleton : Device = Device()
    static let currentDevice: UIDevice = UIDevice.current
    static var isPhone: Bool { return currentDevice.userInterfaceIdiom == .phone }
    static var isPad: Bool { return currentDevice.userInterfaceIdiom == .pad}
    private init(){}
}
