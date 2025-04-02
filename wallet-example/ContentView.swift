//
//  ContentView.swift
//  wallet-example
//
//  Created by Daria Kozlovska on 01/04/2025.
//

import SwiftUI
import ReownAppKit

struct ContentView: View {
    
    @State private var showUIComponents: Bool = true
    
    var body: some View {
        NavigationView{
            VStack {
                
                AppKitButton()
                
                Button("Personal sign") {
                    Task {
                        do {
                            try await requestPersonalSign()
                            AppKit.instance.launchCurrentWallet()
                        } catch {
                            print("Error occurred: \(error)")
                        }
                    }
                }
                .buttonStyle(W3MButtonStyle())
            }
            .padding()
        }
    }
    func requestPersonalSign() async throws {
        guard let address = AppKit.instance.getAddress() else { return }
        try await AppKit.instance.request(.personal_sign(address: address, message: "Hello there!"))

    }
}


//user przesyła info ze swojego konta na contract, param: address from i address to 
