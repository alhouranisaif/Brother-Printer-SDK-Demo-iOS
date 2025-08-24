//
//  BluetoothPrinterSearcher.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/13.
//

import BRLMPrinterKit
import Foundation

class BluetoothPrinterSearcher: IPrinterSearcher {
    func start(callback: @escaping (String?, [DiscoveredPrinterInfo]?) -> Void) {
        DispatchQueue.global().async {
            let searcher = BRLMPrinterSearcher.startBluetoothSearch()
            let list = searcher.channels.map({
                let info = DiscoveredPrinterInfo()
                info.printerItemData.channelType = BRLMChannelType.bluetoothMFi
                info.printerItemData.modelName = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyModelName) as? String ?? ""
                info.printerItemData.channelInfo = $0.channelInfo
                info.printerItemData.ipaddress = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyIpAddress) as? String
                info.printerItemData.advertiseLocalName = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyAdvertiseLocalName) as? String
                info.printerItemData.macAddress = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyMacAddress) as? String
                info.printerItemData.nodeName = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyNodeName) as? String
                info.printerItemData.location = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyLocation) as? String
                info.printerItemData.serialNumber = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeySerialNumber) as? String
                return info
            })
            DispatchQueue.main.async {
                callback(searcher.error.code.name, list)
            }
        }
    }

    func cancel() {
        // ignore
    }
}
