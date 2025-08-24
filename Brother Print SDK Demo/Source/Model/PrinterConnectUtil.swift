//
//  PrinterConnectUtil.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/22.
//

import BRLMPrinterKit
import Foundation

class PrinterConnectUtil {

    func fetchCurrentChannel(printerInfo: DiscoveredPrinterInfo) -> BRLMChannel? {
        switch printerInfo.printerItemData.channelType {
        case .bluetoothMFi:
            return BRLMChannel(bluetoothSerialNumber: printerInfo.printerItemData.channelInfo)
        case .wiFi:
            return BRLMChannel(wifiIPAddress: printerInfo.printerItemData.channelInfo)
        case .bluetoothLowEnergy:
            return BRLMChannel(bleLocalName: printerInfo.printerItemData.channelInfo)
        @unknown default:
            return nil
        }
    }

}
