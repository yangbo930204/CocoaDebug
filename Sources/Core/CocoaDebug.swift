//
//  CocoaDebug
//  liman
//
//  Created by liman 02/02/2023.
//  Copyright © 2023 liman. All rights reserved.
//

import Foundation
import UIKit

@objc public class CocoaDebug: NSObject {
    /// if the captured URLs contain server URL, CocoaDebug set server URL bold font to be marked. Not mark when this value is nil. Default value is `nil`.
    @objc public static var serverURL: String?
    /// set the URLs which should not been captured, CocoaDebug capture all URLs when the value is nil. Default value is `nil`.
    @objc public static var ignoredURLs: [String]?
    /// set the URLs which are only been captured, CocoaDebug capture all URLs when the value is nil. Default value is `nil`.
    @objc public static var onlyURLs: [String]?
    /// set the prefix Logs which should not been captured, CocoaDebug capture all Logs when the value is nil. Default value is `nil`.
    @objc public static var ignoredPrefixLogs: [String]?
    /// set the prefix Logs which are only been captured, CocoaDebug capture all Logs when the value is nil. Default value is `nil`.
    @objc public static var onlyPrefixLogs: [String]?
    /// add an additional UIViewController as child controller of CocoaDebug's main UITabBarController. Default value is `nil`.
    @objc public static var additionalViewController: UIViewController?
    /// set the initial recipients to include in the email’s “To” field when share via email. Default value is `nil`.
    @objc public static var emailToRecipients: [String]?
    /// set the initial recipients to include in the email’s “Cc” field when share via email. Default value is `nil`.
    @objc public static var emailCcRecipients: [String]?
    /// set CocoaDebug's main color with hexadecimal format. Default value is `#42d459`.
    @objc public static var mainColor: String = "#42d459"
    /// protobuf url and response class transfer map. Default value is `nil`.
    @objc public static var protobufTransferMap: [String: [String]]?
    @objc public static var bubbleColor: String = "#000000"
    @objc public static var bubbleTextColor: String = "#111111"
    /// 加密的内容,需要解密回调
    @objc public static var decryptBlock: ((_ data: [String: Any]) -> [String: Any])?

    // MARK: - CocoaDebug enable

    @objc public static func enable() {
        initializationMethod(serverURL: serverURL, ignoredURLs: ignoredURLs, onlyURLs: onlyURLs, ignoredPrefixLogs: ignoredPrefixLogs, onlyPrefixLogs: onlyPrefixLogs, additionalViewController: additionalViewController, emailToRecipients: emailToRecipients, emailCcRecipients: emailCcRecipients, mainColor: mainColor, protobufTransferMap: protobufTransferMap)
    }

    // MARK: - CocoaDebug disable

    @objc public static func disable() {
        deinitializationMethod()
    }

    // MARK: - hide Bubble

    @objc public static func hideBubble() {
        CocoaDebugSettings.shared.showBubbleAndWindow = false
    }

    // MARK: - show Bubble

    @objc public static func showBubble() {
        CocoaDebugSettings.shared.showBubbleAndWindow = true
    }

    // MARK: - 自定义的更多

    @objc public static func addEnvironmentSwitch(_ type: Int, completionHandler: @escaping SelectFinishNetworkCallBack) {
        let vc = SwitchEnvironmentViewController()
        switch type {
        case 1:
            vc.currentNetwork = .production
        case 2:
            vc.currentNetwork = .preProduction
        default:
            vc.currentNetwork = .testing
        }
        vc.switchNetworkDoneCallBack = { type in
            completionHandler(type)
        }
        CocoaDebug.additionalViewController = vc
    }

    @objc public static func addMoreHeaderView(_ view: UIView) {
        if let vc = CocoaDebug.additionalViewController as? SwitchEnvironmentViewController {
            vc.tableHeaderView = view
        }
    }

    @objc public static func addMoreTool(_ eventModel: CocoaEventModel) {
        if let vc = CocoaDebug.additionalViewController as? SwitchEnvironmentViewController {
            vc.addEventModel(eventModel)
        }
    }

    @objc public static func selectEnvironment(window: UIWindow!,
                                               completionHandler: @escaping SelectFinishNetworkCallBack) {
        SelectingNetworksViewController.didFinishLaunching(window: window, completionHandler: completionHandler)
    }
}

// MARK: - override Swift `print` method

public func print<T>(file: String = #file, function: String = #function, line: Int = #line, _ message: T, color: UIColor = .white) {
    Swift.print(message)
    _SwiftLogHelper.shared.handleLog(file: file, function: function, line: line, message: message, color: color)
}
