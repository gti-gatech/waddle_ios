//
//  SocketIOManager.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager {

    static let shared = SocketIOManager()
    var socket: SocketIOClient!

    let manager = SocketManager(socketURL: URL(string: "http://34.209.64.150:8000")!, config: [.log(true), .compress])

    private init() {
        socket = manager.defaultSocket
    }

    func connectSocket(completion: @escaping(Bool) -> () ) {
        disconnectSocket()
        socket.on(clientEvent: .connect) {[weak self] (data, ack) in
            print("socket connected")
            self?.socket.removeAllHandlers()
            completion(true)
        }
        socket.connect()
    }

    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
    }

    func checkConnection() -> Bool {
        if socket.manager?.status == .connected {
            return true
        }
        return false

    }

    enum Events {
        
        case markPresent
        case tripStatusChanged
        case updateLocation
        case joinTripUpdates
        case sendMessage
        case joinMessageUpdates
        case newMessageListener
        case readMessage
        
        var emitterName: String {
            switch self {
            case .markPresent:
                return "markPresent"
            case .updateLocation:
                return "updateLocation"
            case .joinTripUpdates:
                return "joinTripUpdates"
            case .sendMessage:
                return "addMessage"
            case .joinMessageUpdates:
                return "joinMessageUpdates"
            case .readMessage:
                return "readMessage"
                
            default:
                return ""
            }
        }
        
        var listnerName: String {
            switch self {
            case .tripStatusChanged:
                return "tripStatusChanged"
            case .newMessageListener:
                return "newMessageListener"
                
            default:
                return ""
            }
        }
        
        func emit(params: [String : Any]) {
            SocketIOManager.shared.socket.emit(emitterName, params)
        }
        
        func listen(completion: @escaping (Any) -> Void) {
            SocketIOManager.shared.socket.on(listnerName) { (response, emitter) in
                completion(response)
            }
        }
        
        func off() {
            SocketIOManager.shared.socket.off(listnerName)
        }
    }
}
