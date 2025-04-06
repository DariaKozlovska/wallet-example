////
////  TransactionView.swift
////  wallet-example
////
////  Created by Daria Kozlovska on 05/04/2025.
////
//
//import ReownAppKit
//import SwiftUI
//import BigInt
//import AsyncButton
//import Web3
//
//
//struct TransactionView: View {
//    @State private var decimalValue = "0.001"
//    @State private var hexValue = "0x1"
//    @State var result: String = ""
//    @State private var errorMessage = ""
//    @State private var showError = false
//    @State private var to = "0x0000000000000000000000000000000000000000"
//    @State var isConnectWith: Bool = false
//    @State private var sendTransactionTitle = "Send Transaction"
//    @State private var connectWithSendTransactionTitle = "Connect & Send Transaction"
//    
//    @State private var showProgressView = false
//    
//    @Environment(\.dismiss) var dismiss
//    @FocusState private var amountFieldIsFocused: Bool
//    
//    var body: some View {
//        VStack {
//            VStack(spacing: 8) {
//                HStack {
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("My Address")
//                            .foregroundColor(.gray)
//                        Text(address()) // <- tutaj używamy funkcji, ale jest już na zewnątrz
//                            .font(.system(.body, design: .monospaced))
//                            .lineLimit(1)
//                            .minimumScaleFactor(0.5)
//                    }
//                    Spacer()
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color("grey-section"))
//            .cornerRadius(12)
//            
//            VStack(spacing: 20) {
//                Text("Transaction")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                // Recipient
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Recipient")
//                        .foregroundColor(.gray)
//                    TextField("0x1234... or ENS", text: $to)
//                        .textFieldStyle(.roundedBorder)
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
//                }
//                
//                // Amount + network
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Amount to send")
//                        .foregroundColor(.gray)
//                    
//                    HStack {
//                        TextField("0.00", text: $decimalValue)
//                            .keyboardType(.decimalPad)
//                            .textFieldStyle(.roundedBorder)
//                            .focused($amountFieldIsFocused)
//                            .toolbar {
//                                ToolbarItemGroup(placement: .keyboard) {
//                                    Spacer()
//                                    Button("Done") {
//                                        amountFieldIsFocused = false
//                                    }
//                                }
//                            }
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color("grey-section"))
//            .cornerRadius(12)
//            
//            Spacer()
//            
//            VStack(spacing: 12) {
//                AsyncButton(
//                    options: [
//                        .showProgressViewOnLoading,
//                        .disableButtonOnLoading,
//                        .showAlertOnError,
//                        .enableNotificationFeedback
//                    ]
//                ) {
//                    try await sendTransaction()
//                    AppKit.instance.launchCurrentWallet()
//                } label: {
//                    Text("Send")
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(
//                            LinearGradient(
//                                gradient: Gradient(colors: [.blue, .purple]),
//                                startPoint: .leading,
//                                endPoint: .trailing
//                            )
//                        )
//                        .cornerRadius(12)
//                }
//            }
//            .padding()
//        }
//    }
//    
//    // Funkcje pomocnicze przeniesione na zewnątrz body!
//    func sendTransaction() async throws {
//        showProgressView = true
//            errorMessage = ""
//            
//        do {
//            guard let fromAddressString = AppKit.instance.getAddress(),
//                  let fromAddress = try? EthereumAddress(hex: fromAddressString, eip55: false) else {
//                throw NSError(domain: "TransactionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid sender address"])
//            }
//            
//            guard !to.isEmpty, let toAddress = try? EthereumAddress(hex: to, eip55: false) else {
//                throw NSError(domain: "TransactionError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid recipient address"])
//            }
//            
//            guard let decimalAmount = Decimal(string: decimalValue), decimalAmount > 0,
//                  let weiAmount = BigUInt((decimalAmount * pow(10, 18)).description) else {
//                throw NSError(domain: "TransactionError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid amount"])
//            }
//            let value = EthereumQuantity(quantity: weiAmount)
//
//            try await AppKit.instance.request(.eth_sendTransaction(from: fromAddressString, to: to, value: "0x1", data: "0x0", nonce: 32891756, gas: nil, gasPrice: "0x0", maxFeePerGas: nil, maxPriorityFeePerGas: nil, gasLimit: "0x0", chainId: "eip155:1"))
//            
//
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = error.localizedDescription
//                self.showError = true
//                self.showProgressView = false
//            }
//            throw error
//        }
//    }
//    
//    func address() -> String {
//        if let address = AppKit.instance.getAddress() {
//            return address
//        } else {
//            return "No address found"
//        }
//    }
//}
//
////import Foundation
////
////struct EthSendTransaction: Codable, Equatable {
////    let from: String
////    let data: String
////    let value: String
////    let to: String
////    let gasPrice: String
////    let nonce: String
////
////    static func stub() -> EthSendTransaction {
////        try! JSONDecoder().decode(EthSendTransaction.self, from: ethSendTransactionJSON.data(using: .utf8)!)
////    }
////
////    private static let ethSendTransactionJSON = """
////{
////    "from":"0xb60e8dd61c5d32be8058bb8eb970870f07233155",
////    "to":"0xd46e8dd67c5d32be8058bb8eb970870f07244567",
////    "data":"0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675",
////    "gas":"0x76c0",
////    "gasPrice":"0x9184e72a000",
////    "value":"0x9184e72a",
////    "nonce":"0x117"
////}
////"""
////}
import SwiftUI

struct SendEthereumView: View {
    @StateObject private var presenter = SendEthereumPresenter()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case toAddress, amount
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Nagłówek
            Text("Send Ethereum")
                .font(.title)
                .padding(.bottom, 20)
            
            // Pole "From" - tylko do odczytu
            VStack(alignment: .leading, spacing: 5) {
                Text("From")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("", text: $presenter.fromAddress)
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
            }
            
            // Pole "To"
            VStack(alignment: .leading, spacing: 5) {
                Text("To Address (0x...)")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter recipient address", text: $presenter.toAddress)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .toAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            // Pole "Amount"
            VStack(alignment: .leading, spacing: 5) {
                Text("Amount (ETH)")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("0.01", text: $presenter.amount)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .amount)
                    .keyboardType(.decimalPad)
            }
            
            // Przycisk wysyłania
            Button(action: {
                Task {
                    await presenter.sendTransaction()
                }
            }) {
                if presenter.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Send Transaction")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(presenter.isLoading)
            .padding(.top, 20)
            
            // Pokaz hash transakcji jeśli istnieje
            if let hash = presenter.transactionHash {
                VStack {
                    Text("Transaction sent!")
                        .foregroundColor(.green)
                    Text(hash)
                        .font(.system(size: 12, design: .monospaced))
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
        .onTapGesture {
            // Ukryj klawiaturę po tapnięciu poza polami tekstowymi
            focusedField = nil
        }
    }
}
