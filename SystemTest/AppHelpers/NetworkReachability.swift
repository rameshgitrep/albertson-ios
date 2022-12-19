//
//  NetworkReachability.swift
//  SystemTest
//
//  Created by Ramesh Maddali on 18/12/22.
//

import Reachability

class NetworkReachability {
    static let shared = NetworkReachability()
    
    func isNetworkAvailable() -> Bool {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            return false
        }
        return true
    }
}
