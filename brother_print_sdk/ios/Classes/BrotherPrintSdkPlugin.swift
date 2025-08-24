import Flutter
import UIKit
import BRLMPrinterKit

public class BrotherPrintSdkPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "brother_print_sdk", binaryMessenger: registrar.messenger())
    let event = FlutterEventChannel(name: "brother_print_sdk/events", binaryMessenger: registrar.messenger())
    let instance = BrotherPrintSdkPlugin()
    event.setStreamHandler(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "startNetworkSearch":
      startNetworkSearch(result: result)
    case "cancelSearch":
      cancelSearch()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private var eventSink: FlutterEventSink?
  private var cancelRoutine: (() -> Void)?

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }

  private func startNetworkSearch(result: @escaping FlutterResult) {
    DispatchQueue.global().async {
      self.cancelRoutine = {
        BRLMPrinterSearcher.cancelNetworkSearch()
      }
      let option = BRLMNetworkSearchOption()
      option.searchDuration = 15
      let searcher = BRLMPrinterSearcher.startNetworkSearch(option) { channel in
        var payload: [String: Any] = [:]
        payload["channelType"] = "wifi"
        payload["modelName"] = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyModelName) as? String ?? ""
        payload["channelInfo"] = channel.channelInfo
        payload["ipAddress"] = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyIpAddress) as? String
        payload["advertiseLocalName"] = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyAdvertiseLocalName) as? String
        payload["macAddress"] = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyMacAddress) as? String
        payload["nodeName"] = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyNodeName) as? String
        payload["location"] = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyLocation) as? String
        payload["serialNumber"] = channel.extraInfo?.value(forKey: BRLMChannelExtraInfoKeySerialNumber) as? String
        DispatchQueue.main.async {
          self.eventSink?(payload)
        }
      }
      self.cancelRoutine = nil
      DispatchQueue.main.async {
        if searcher.error.code == .noError {
          result(nil)
        } else {
          let message = String(describing: searcher.error.code)
          result(FlutterError(code: "search_error", message: message, details: nil))
        }
      }
    }
  }

  private func cancelSearch() {
    DispatchQueue.global().async {
      self.cancelRoutine?()
      self.cancelRoutine = nil
    }
  }
}
