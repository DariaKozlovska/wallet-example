//
//  SendEthPresenter.swift
//  wallet-example
//
//  Created by Daria Kozlovska on 05/04/2025.
//

import Foundation
import BigInt
import WalletConnectSign
import ReownAppKit

final class SendEthereumPresenter: ObservableObject {
    @Published var fromAddress: String = ""
    @Published var toAddress: String = ""
    @Published var amount: String = "0.01"
    @Published var isLoading: Bool = false
    @Published var transactionHash: String?
    
    init() {
        Task {
            await loadAddress()
        }
    }
    
    @MainActor
    private func loadAddress() {
        Task {
            do {
                let fromAddress = try await AppKit.instance.getAddress()
            } catch {
                print("Error loading address: \(error)")
            }
        }
    }
    
    func sendTransaction() async {
        guard !isLoading else { return }
        
        do {
            await MainActor.run { isLoading = true }
            
            // Walidacja danych
            guard !toAddress.isEmpty else {
                throw NSError(domain: "Recipient address is empty", code: 0)
            }
            
            guard let decimalAmount = Decimal(string: amount) else {
                throw NSError(domain: "Invalid amount format", code: 0)
            }
            
            // Przygotowanie wartości w wei (1 ETH = 10^18 wei)
            let weiAmount = decimalAmount * pow(10, 18)
            guard let bigUIntAmount = BigUInt(weiAmount.description) else {
                throw NSError(domain: "Amount conversion error", code: 0)
            }
            
            let hexValue = "0x" + String(bigUIntAmount, radix: 16)
            do {
                let sessions = try await AppKit.instance.getSessions()
                
                let params: [String: AnyCodable] = [
                    "from": AnyCodable(fromAddress),
                    "to": AnyCodable(toAddress),
                    "value": AnyCodable(hexValue)
                ]
                
                guard let chainId = Blockchain("eip155:1") else {
                    print("Error: Invalid chain ID")
                    return
                }
                
                for session in sessions {
                    let topic = session.topic
                    
                    do {
                        try await AppKit.instance.request(
                            params: .init(
                                topic: topic,
                                method: "eth_sendTransaction",
                                params: AnyCodable(params),
                                chainId: chainId
                            )
                        )
                        print("Transaction request sent successfully for session: \(topic)")
                    } catch {
                        print("Error sending transaction request for session \(topic): \(error)")
                        // Continue with next session even if one fails
                        continue
                    }
                }
            } catch {
                print("Error fetching sessions: \(error)")
            }
            
        } catch {
            print("Transaction error: \(error)")
            await MainActor.run { isLoading = false }
            // Tutaj możesz dodać obsługę błędów
        }
        
        await MainActor.run { isLoading = false }
    }
}
