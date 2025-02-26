//
//  QRScannerView.swift
//  QRCode_Scan
//
//  Created by MacMini6 on 26/02/25.
//

import SwiftUI
import AVFoundation

struct QRScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?
    @Binding var isScanning: Bool
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(scannedCode: $scannedCode, isScanning: $isScanning)
    }
    
    func makeUIViewController(context: Context) -> QRScannerViewController {
        let viewController = QRScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {}
    
    class Coordinator: NSObject, QRScannerViewControllerDelegate {
        @Binding var scannedCode: String?
        @Binding var isScanning: Bool
        
        init(scannedCode: Binding<String?>, isScanning: Binding<Bool>) {
            _scannedCode = scannedCode
            _isScanning = isScanning
        }
        
        func didScanQRCode(_ code: String) {
            scannedCode = code
            isScanning = false
        }
        
        func didCancelScanning() {
            isScanning = false
        }
    }
}
