//
//  PrinterInfoView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import SwiftUI

protocol PrinterInfoViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func requestMainFirmVersionDidTap()
    func requestSerialNumberDidTap()
    func getStatusDidTap()
    func requestSystemReportDidTap()
    func requestMediaVersionDidTap()
    func requestBatteryDidTap()
    func requestTemplateInfoListDidTap()
    func requestIsBootModeTap()
    func requestPrinterInternalModelFlagTap()
    func requestBluetoothFirmVersionDidTap()

}

struct PrinterInfoView: View {
    weak var delegate: PrinterInfoViewDelegate?
    @ObservedObject var dataSource: PrinterInfoViewModel
    var body: some View {
        Form {
            Section(content: {
                Button(action: {
                    delegate?.selectPrinterButtonDidTap()
                }, label: {
                    VStack(alignment: .leading) {
                        Text(dataSource.printerInfo?.printerItemData.modelName ?? NSLocalizedString("select_printer_message", comment: ""))
                            .foregroundColor(.black)
                        Text(dataSource.printerInfo?.printerItemData.channelInfo ?? "").font(.footnote).foregroundColor(.gray)
                    }
                })
            }, header: {
                Text("printer").foregroundColor(.gray)
            })
            Section(content:  {
                Button(action: {
                    delegate?.requestMainFirmVersionDidTap()
                }, label: {
                    Text("request_mainfirm_version")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.requestSerialNumberDidTap()
                }, label: {
                    Text("request_serial_number")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.getStatusDidTap()
                }, label: {
                    Text("get_status")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.requestSystemReportDidTap()
                }, label: {
                    Text("request_system_report")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.requestMediaVersionDidTap()
                }, label: {
                    Text("request_media_version")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.requestBatteryDidTap()
                }, label: {
                    Text("request_battery_info")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.requestTemplateInfoListDidTap()
                }, label: {
                    Text("requestTemplateList")
                }).foregroundColor(.black)
            }, header: {
                Text("official_api").foregroundColor(.gray)
            })
            Section(content:  {
                Button(action: {
                    delegate?.requestIsBootModeTap()
                }, label: {
                    Text("request_is_boot")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.requestPrinterInternalModelFlagTap()
                }, label: {
                    Text("request_internal_flag")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.requestBluetoothFirmVersionDidTap()
                }, label: {
                    Text("request_bluetooth_firm_version")
                }).foregroundColor(.black)
            }, header: {
                Text("brother_api").foregroundColor(.gray)
            })
        }
    }
}

struct PrinterInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PrinterInfoView(dataSource: .init())
    }
}
