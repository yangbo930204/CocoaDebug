//
//  Example
//  man
//
//  Created by man 11/11/2018.
//  Copyright © 2020 man. All rights reserved.
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

    @objc public static func selectNetwork(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
                                           window: UIWindow!,
                                           completionHandler: @escaping SelectFinishNetworkCallBack) {
        MoreViewController.didFinishLaunching(launchOptions, window: window, completionHandler: completionHandler)
    }

    // MARK: - 自定义的更多

    @objc public static func customMore(completionHandler: @escaping SelectFinishNetworkCallBack) {
        CocoaDebug.additionalViewController = MoreViewController()
    }

    @objc public static func addEnvironmentSwitch(_ type: Int, completionHandler: @escaping SelectFinishNetworkCallBack) {
        let vc = SwitchEnvironmentViewController()
        switch type {
        case 1:
            vc.currentNetworkString = "Current: Production Environment"
        case 2:
            vc.currentNetworkString = "Current: Pre Production Environment"
        default:
            vc.currentNetworkString = "Current: Testing Environment"
        }
        vc.switchNetworkDoneCallBack = { type in
            completionHandler(type)
        }
        CocoaDebug.additionalViewController = vc
    }
}

// MARK: - override Swift `print` method

public func print<T>(file: String = #file, function: String = #function, line: Int = #line, _ message: T, color: UIColor = .white) {
    Swift.print(message)
    _SwiftLogHelper.shared.handleLog(file: file, function: function, line: line, message: message, color: color)
}
