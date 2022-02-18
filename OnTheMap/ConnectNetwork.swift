//
//  ConnectNetwork.swift
//  OnTheMap
//
//  Created by Talita Groppo on 18/02/2022.
//

import Foundation
import Network

final class ConnectNetwork {
    
    static let shared = ConnectNetwork()
    
    private let queue = DispatchQueue.global()
    
    private let connect: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType = .unknow
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknow
    }
    
    private init() {
        connect = NWPathMonitor()
    }
    public func startMonitoring(){
        connect.start(queue: queue)
        connect.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    public func stopMonitoring() {
        connect.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        }
       else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        }
       else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
    }
else {
    connectionType = .unknow
}
}
}
