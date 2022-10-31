//
//  NetworkMotinor.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 29.10.2022.
//

import Network
import Foundation

final class NetworkMonitor {
    
    // MARK: - NetworkMonitor variables and constants
    
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    
    private(set) var isConnected = false
    // Expensive in terms of traffic consumption. For example, cellular interfaces are considered more expensive than Wi-Fi etc.
    private(set) var isExpensive = false
    //Indicates the type of current connection on the network to which we are connected.
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    // MARK: - Life cycle
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    // MARK: - Start network monitoring
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.isExpensive = path.isExpensive
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
            
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        monitor.start(queue: queue)
    }
    
    // MARK: - Stop network monitoring
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

//MARK: - Implementation for accessing the allCases property in NWInterface.InterfaceType

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

//MARK: - Notification.Name extension

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}
