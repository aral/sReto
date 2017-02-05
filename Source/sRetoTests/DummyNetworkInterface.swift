//
//  DummyNetworkInterface.swift
//  sReto
//
//  Created by Julian Asamer on 17/09/14.
//  Copyright (c) 2014 - 2016 Chair for Applied Software Engineering
//
//  Licensed under the MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness
//  for a particular purpose and noninfringement. in no event shall the authors or copyright holders be liable for any claim, damages or other liability, 
//  whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.
//

import Foundation

class DummyNetworkInterface {
    let interfaceName: String
    var browsers: Set<DummyBrowser> = []
    var advertisers: Set<DummyAdvertiser> = []
    let recommendedPacketSize: Int = 1024
    let cost: Int

    init(interfaceName: String, cost: Int) {
        self.interfaceName = interfaceName
        self.cost = cost
    }
    
    func register(browser: DummyBrowser) {
        browsers += browser
        for advertiser in advertisers {
            self.notifyAddPeer(browser: browser, advertiser)
        }
    }
    func unregister(browser: DummyBrowser) {
        browsers -= browser
        for advertiser in advertisers {
            self.notifyRemovePeer(browser: browser, advertiser)
        }
    }
    
    func register(advertiser: DummyAdvertiser) {
        advertisers += advertiser
        for browser in browsers {
            self.notifyAddPeer(browser: browser, advertiser)
        }
    }
    func unregister(advertiser: DummyAdvertiser) {
        advertisers -= advertiser
        for browser in browsers {
            self.notifyRemovePeer(browser: browser, advertiser)
        }
    }
    
    func notifyAddPeer(browser: DummyBrowser, _ advertiser: DummyAdvertiser) {
        DispatchQueue.main.async {
            browser.onAddPeer(identifier: advertiser.identifier, address: DummyAddress(networkInterface: self, advertiser: advertiser))
        }
    }
    func notifyRemovePeer(browser: DummyBrowser, _ advertiser: DummyAdvertiser) {
        DispatchQueue.main.async {
            browser.onRemovePeer(identifier: advertiser.identifier)
        }
    }
}
