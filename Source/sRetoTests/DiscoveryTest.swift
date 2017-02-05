//
//  DiscoveryTest.swift
//  sReto
//
//  Created by Julian Asamer on 20/09/14.
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

import UIKit
import XCTest

class DiscoveryTest: XCTestCase {
    override func setUp() {
        super.setUp()
        broadcastDelaySettings = (0.01, 0.05)
    }
    
    func testDiscoveryDirect() {
        self.testDiscovery(configuration: PeerConfiguration.directNeighborConfiguration())
    }
    func testDiscovery2Hop() {
        self.testDiscovery(configuration: PeerConfiguration.twoHopRoutedConfiguration())
    }
    func testDiscovery4Hop() {
        self.testDiscovery(configuration: PeerConfiguration.fourHopRoutedConfiguration())
    }
    
    func testDiscovery(configuration: PeerConfiguration) {
        let allPeersDiscoveredExpectation = self.expectation(description: "all peers discovered")
        var reachablePeerIdentifiers = configuration.reachablePeerIdentifiers - [configuration.primaryPeer.identifier]
        
        configuration.primaryPeer.start(onPeerDiscovered: {
            reachablePeerIdentifiers -= $0.identifier
            
            if reachablePeerIdentifiers.count == 0 {
                allPeersDiscoveredExpectation.fulfill()
            }
        }, onPeerRemoved: { _ in ()}, onIncomingConnection: {_ in ()}, displayName: nil)
        
        for peer in configuration.participatingPeers - [configuration.primaryPeer] {
            peer.start(onPeerDiscovered: {_ in ()}, onPeerRemoved: {_ in ()}, onIncomingConnection: {_ in ()}, displayName: nil)
        }
        
        self.waitForExpectations(timeout: 30, handler: { error in () })
    }
}
