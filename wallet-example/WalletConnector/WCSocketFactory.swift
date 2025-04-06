//
//  DefaultSocketFactory.swift
//  wallet-example
//
//  Created by Daria Kozlovska on 02/04/2025.
//

import Foundation
import WalletConnectRelay
import Starscream

extension WebSocket: WebSocketConnecting {}

struct DefaultSocketFactory: WebSocketFactory {
    func create(with url: URL) -> WebSocketConnecting {
        let socket = WebSocket(url: url)
        let queue = DispatchQueue(label: "com.walletconnect.sdk.sockets", attributes: .concurrent)
        socket.callbackQueue = queue
        return socket
    }
}
