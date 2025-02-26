//
//  ContentView.swift
//  QRCode_Scan
//
//  Created by MacMini6 on 26/02/25.
//
import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @State private var scannedCode: String?
    @State private var showScanner = false
    @State private var pairingMessage: String?
    @State private var isPairing = false
    @State private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Smartwatch QR Scanner")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.blue)
            
            if let scannedCode = scannedCode {
                Button(action: {
                    handleScannedCode(scannedCode)
                }) {
                    Text("📎 \(scannedCode)")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            
            if isPairing {
                ProgressView("Pairing with smartwatch...")
            }
            
            if let message = pairingMessage {
                Text(message)
                    .font(.headline)
                    .foregroundColor(message == "Paired Successfully 🎉" ? .green : .red)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                showScanner = true
            }) {
                HStack {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title)
                    Text("Scan QR Code")
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal)
            }
            .fullScreenCover(isPresented: $showScanner) {
                QRScannerView(scannedCode: $scannedCode, isScanning: $showScanner)
            }
            
            Spacer()
        }
        .onChange(of: scannedCode) { newCode in
            if let newCode = newCode {
                pairSmartwatch(with: newCode)
            }
        }
    }
    
    func pairSmartwatch(with qrCode: String) {
        isPairing = true
        pairingMessage = nil
        
        bluetoothManager.connectToSmartwatch(qrCode: qrCode) { success in
            DispatchQueue.main.async {
                isPairing = false
                pairingMessage = success ? "Paired Successfully 🎉" : "Pairing Failed ❌"
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if isPairing {
                isPairing = false
                pairingMessage = "Pairing Timeout ⏳"
            }
        }
    }
    
    func handleScannedCode(_ code: String) {
        if let url = URL(string: code), url.scheme == "http" || url.scheme == "https" {
            UIApplication.shared.open(url)
        } else {
            UIPasteboard.general.string = code
            pairingMessage = "Copied to Clipboard ✅"
        }
    }
}

#Preview {
    ContentView()
}
