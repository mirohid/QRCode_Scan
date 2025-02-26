//
//  ContentView.swift
//  QRCode_Scan
//
//  Created by MacMini6 on 26/02/25.
//

import SwiftUI

struct ContentView: View {
    @State private var scannedCode: String?
    @State private var showScanner = false // Controls scanner visibility
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("QR Code Scanner")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                
                if let scannedCode = scannedCode {
                    Text("Scanned Code: \(scannedCode)")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Scan Button
                Button(action: {
                    withAnimation {
                        showScanner.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.title)
                        Text(showScanner ? "Close Scanner" : "Scan QR Code")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(showScanner ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            
            // Camera Scanner (Appears when button is tapped)
            if showScanner {
                ZStack {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10)
                        .overlay(
                            QRScannerView(scannedCode: $scannedCode)
                                .frame(width: 280, height: 280)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        )
                }
                .transition(.scale)
            }
        }
        .animation(.easeInOut, value: showScanner)
    }
}
#Preview {
    ContentView()
}
