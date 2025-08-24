//
//  TransferFilesView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import SwiftUI

protocol TransferFilesViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func transferFirmwareFilesDidTap()
    func transferTemplateFilesDidTap()
    func transferDatabaseFilesDidTap()
    func transferBinaryFilesDidTap()
    func transferBinaryDataDidTap()
}

struct TransferFilesView: View {
    weak var delegate: TransferFilesViewDelegate?
    @ObservedObject var dataSource: TransferFilesViewModel
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
                Text("Printer").foregroundColor(.gray)
            })
            Section {
                Button(action: {
                    delegate?.transferFirmwareFilesDidTap()
                }, label: {
                    Text("transferFirmwareFiles")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.transferTemplateFilesDidTap()
                }, label: {
                    Text("transferTemplateFiles")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.transferDatabaseFilesDidTap()
                }, label: {
                    Text("transferDatabaseFiles")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.transferBinaryFilesDidTap()
                }, label: {
                    Text("transferBinaryFiles")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.transferBinaryDataDidTap()
                }, label: {
                    Text("transferBinaryData")
                }).foregroundColor(.black)
            }
        }
    }
}

struct TransferFilesView_Previews: PreviewProvider {
    static var previews: some View {
        TransferFilesView(dataSource: .init())
    }
}
