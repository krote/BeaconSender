//
//  IBeaconManager.swift
//  BeaconCatcher
//
//  Created by krote on 2023/09/21.
//

import Foundation
import CoreBluetooth

class IBeaconManager: NSObject, CBPeripheralManagerDelegate {

    private var beaconPeripheralData: BeaconData!
    private var peripheralManager: CBPeripheralManager!

    private let BEACON_ID: String = "iBeacon"
    private let uuid: UUID = UUID(uuidString: "79B5188A-714A-4515-9465-14C4DEB03A40")!
    private let MAJOR: UInt16 = 7
    private let MINOR: UInt16 = 8
    private var beaconStatus:Bool = false
        
    // Beaconを設定
    func initBeacon() {
        if beaconPeripheralData != nil {
            stopLocalBeacon()
        }
        beaconPeripheralData = BeaconData(proximityUUID: self.uuid, major: self.MAJOR, minor: self.MINOR, measuredPower: -60)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        beaconStatus = true
    }
    
    // Beaconを停止
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        beaconStatus = false
        print("end beacon")
    }
 
    // Bluetoothの電源が切り替わった際に実行される処理
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("can use bluetooth")
            if(peripheralManager != nil){
                peripheralManager.startAdvertising(beaconPeripheralData.advertisement)
                print("start advertisement")
            }
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
            print("bluetooth power off")
        } else if peripheral.state == .unsupported{
            print("bluetooth no support")
        }
    }
    
    // iBeaconの発信が始まると走る関数
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager,error: Error?) {
        if (error != nil) {
            print("Failed to start advertisement" + error!.localizedDescription)
        }
    }
}

// iBeacon用に自作したクラス
final class BeaconData: NSObject {

    var advertisement: [String: Any]
    
    init(proximityUUID: UUID?, major: UInt16?, minor: UInt16?, measuredPower: Int8?) {
        var buffer = [CUnsignedChar](repeating: 0, count: 21)
        (proximityUUID! as NSUUID).getBytes(&buffer)
        buffer[16] = CUnsignedChar(major! >> 8)
        buffer[17] = CUnsignedChar(major! & 255)
        buffer[18] = CUnsignedChar(minor! >> 8)
        buffer[19] = CUnsignedChar(minor! & 255)
        buffer[20] = CUnsignedChar(bitPattern: measuredPower!)
        let data = Data(bytes: buffer, count: buffer.count)
        advertisement = ["kCBAdvDataAppleBeaconKey": data]
    }
}
