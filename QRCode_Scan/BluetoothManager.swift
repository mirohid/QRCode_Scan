//
//  BluetoothManager.swift
//  QRCode_Scan
//
//  Created by MacMini6 on 26/02/25.
//


import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    private var targetPeripheral: CBPeripheral?
    private var pairingCompletion: ((Bool) -> Void)?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    func connectToSmartwatch(qrCode: String, completion: @escaping (Bool) -> Void) {
        self.pairingCompletion = completion
        
        // Ensure Bluetooth is ON before scanning
        if centralManager.state != .poweredOn {
            completion(false)
            return
        }
        
        print(" Scanning for devices...")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        // Stop scanning after 8 seconds if no device found
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            if self.targetPeripheral == nil { // No device found
                self.centralManager.stopScan()
                completion(false)
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print(" Bluetooth is OFF")
            pairingCompletion?(false)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(" Found device: \(peripheral.name ?? "Unknown")")
        
        // Check if the QR code matches a Bluetooth device name
        if let name = peripheral.name, name.contains("Watch") {
            print(" Found smartwatch! Connecting...")
            centralManager.stopScan()
            
            targetPeripheral = peripheral
            targetPeripheral?.delegate = self
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print(" Successfully connected to \(peripheral.name ?? "Watch")")
        pairingCompletion?(true)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(" Failed to connect")
        pairingCompletion?(false)
    }
}
