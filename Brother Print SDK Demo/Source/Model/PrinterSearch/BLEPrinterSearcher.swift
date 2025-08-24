//
//  BLEPrinterSearcher.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/13.
//

import BRLMPrinterKit
import Foundation

class BLEPrinterSearcher: IPrinterSearcher {
    private var cancelRoutine: (() -> Void)?
    func start(callback: @escaping (String?, [DiscoveredPrinterInfo]?) -> Void) {
        DispatchQueue.global().async {
            self.cancelRoutine = {
                BRLMPrinterSearcher.cancelBLESearch()
            }
            let option = BRLMBLESearchOption()
            option.searchDuration = 5
            let searcher = BRLMPrinterSearcher.startBLESearch(option) { channel in
                let info = DiscoveredPrinterInfo()
                info.printerItemData.channelType = BRLMChannelType.bluetoothLowEnergy
                info.printerItemData.modelName = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyModelName) as? String ?? ""
                info.printerItemData.channelInfo = channel.channelInfo
                info.printerItemData.ipaddress = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyIpAddress) as? String
                info.printerItemData.advertiseLocalName = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyAdvertiseLocalName) as? String
                info.printerItemData.macAddress = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyMacAddress) as? String
                info.printerItemData.nodeName = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyNodeName) as? String
                info.printerItemData.location = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyLocation) as? String
                info.printerItemData.serialNumber = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeySerialNumber) as? String
                DispatchQueue.main.async {
                    callback(nil, [info])
                }
            }
            self.cancelRoutine = nil
            DispatchQueue.main.async {
                callback(searcher.error.code.name, nil)
            }
        }
    }

    func cancel() {
        DispatchQueue.global().async {
            self.cancelRoutine?()
            self.cancelRoutine = nil
        }
    }
}
