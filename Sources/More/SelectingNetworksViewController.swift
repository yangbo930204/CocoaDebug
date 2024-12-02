//
//  SelectingNetworksViewController.swift
//  CocoaDebug
//
//  Created by 杨波 on 2023/4/13.
//

import UIKit

class SelectingNetworksViewController: UIViewController {
    /// 首次选择完成环境的回调
    var firstSelectNetworkDoneCallBack: ((_ type: Int) -> Void)?
    /// 选择环境的回调
    /// 1：生产，2：预生产，3：测试
    var switchNetworkDoneCallBack: ((_ type: Int) -> Void)?
    var currentNetworkLabel: UILabel!

    var type: Int = 0
    var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        title = "Environment Switch"

        bgView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 152))
        view.addSubview(bgView)

        let netType = type

        currentNetworkLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        currentNetworkLabel.textAlignment = .center

        let productionString = SettingEventType.production.rawValue
        let preProductionString = SettingEventType.preProduction.rawValue
        let testingString = SettingEventType.testing.rawValue
        switch netType {
        case 1:
            currentNetworkLabel.text = "当前:\(productionString)"
        case 2:
            currentNetworkLabel.text = "当前:\(preProductionString)"
        case 3:
            currentNetworkLabel.text = "当前:\(testingString)"
        default:
            currentNetworkLabel.text = "请选择环境"
        }

        currentNetworkLabel.textColor = UIColor.white
        bgView.addSubview(currentNetworkLabel)

        let color: UIColor = UIColor.black
        let backgroundColor: UIColor = CocoaDebug.mainColor.hexColor

        let cutNetworkDeveloperButton = UIButton(type: .custom)
        cutNetworkDeveloperButton.frame = CGRect(x: 14, y: 0, width: view.frame.size.width - 28, height: 44)
        cutNetworkDeveloperButton.setTitle(productionString, for: UIControl.State.normal)
        cutNetworkDeveloperButton.addTarget(self, action: #selector(productionButtonAction), for: UIControl.Event.touchUpInside)
        cutNetworkDeveloperButton.setTitleColor(color, for: UIControl.State.normal)
        cutNetworkDeveloperButton.backgroundColor = backgroundColor
        cutNetworkDeveloperButton.layer.masksToBounds = true
        cutNetworkDeveloperButton.layer.cornerRadius = 4
        bgView.addSubview(cutNetworkDeveloperButton)

        let cutNetworkTextButton = UIButton(type: .custom)
        cutNetworkTextButton.frame = CGRect(x: cutNetworkDeveloperButton.frame.origin.x, y: 54,
                                            width: cutNetworkDeveloperButton.frame.size.width, height: 44)
        cutNetworkTextButton.setTitle(preProductionString, for: UIControl.State.normal)
        cutNetworkTextButton.setTitleColor(color, for: UIControl.State.normal)
        cutNetworkTextButton.addTarget(self, action: #selector(grayscaleButtonAction), for: UIControl.Event.touchUpInside)
        cutNetworkTextButton.backgroundColor = backgroundColor
        cutNetworkTextButton.layer.masksToBounds = true
        cutNetworkTextButton.layer.cornerRadius = 4
        bgView.addSubview(cutNetworkTextButton)

        let cutNetworkButton = UIButton(type: .custom)
        cutNetworkButton.frame = CGRect(x: cutNetworkDeveloperButton.frame.origin.x, y: 108,
                                        width: cutNetworkDeveloperButton.frame.size.width, height: 44)
        cutNetworkButton.setTitle(testingString, for: UIControl.State.normal)
        cutNetworkButton.setTitleColor(color, for: UIControl.State.normal)
        cutNetworkButton.addTarget(self, action: #selector(testButtonAction), for: UIControl.Event.touchUpInside)
        cutNetworkButton.backgroundColor = backgroundColor
        cutNetworkButton.layer.masksToBounds = true
        cutNetworkButton.layer.cornerRadius = 4
        bgView.addSubview(cutNetworkButton)

        if netType != 0 {
            let clearDataButton = UIButton(type: .custom)
            clearDataButton.frame = CGRect(x: cutNetworkDeveloperButton.frame.origin.x, y: 162,
                                           width: cutNetworkDeveloperButton.frame.size.width, height: 44)
            clearDataButton.setTitle("Clear all data (reinstall)", for: UIControl.State.normal)
            clearDataButton.setTitleColor(color, for: UIControl.State.normal)
            clearDataButton.addTarget(self, action: #selector(clearDataButtonAction), for: UIControl.Event.touchUpInside)
            clearDataButton.backgroundColor = backgroundColor
            clearDataButton.layer.masksToBounds = true
            clearDataButton.layer.cornerRadius = 4
            bgView.addSubview(clearDataButton)

            bgView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 208)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.center = CGPoint(x: view.bounds.width * 0.5, y: view.bounds.height * 0.5)

        currentNetworkLabel.frame = CGRect(x: 0, y: bgView.frame.origin.y - 84, width: view.frame.size.width, height: 44)
    }

    @objc func productionButtonAction() {
        switchingNetwork(1)
    }

    @objc func grayscaleButtonAction() {
        switchingNetwork(2)
    }

    @objc func testButtonAction() {
        switchingNetwork(3)
    }

    @objc func clearDataButtonAction() {
        switchingNetwork(0)
    }

    func switchingNetwork(_ type: Int) {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)

        if type == 0 {
//            CustomHUD.show("清除数据...")
            let fileManager = FileManager.default
            let myDirectory = NSHomeDirectory() + "/Documents/"
            try? fileManager.removeItem(atPath: myDirectory)
            try? fileManager.createDirectory(atPath: myDirectory, withIntermediateDirectories: true,
                                             attributes: nil)
            let library = NSHomeDirectory() + "/Library/"
            try? fileManager.removeItem(atPath: library)
            try? fileManager.createDirectory(atPath: myDirectory, withIntermediateDirectories: true,
                                             attributes: nil)
            let systemData = NSHomeDirectory() + "/SystemData/"
            try? fileManager.removeItem(atPath: systemData)
            try? fileManager.createDirectory(atPath: myDirectory, withIntermediateDirectories: true,
                                             attributes: nil)
            let tmp = NSHomeDirectory() + "/tmp/"
            try? fileManager.removeItem(atPath: tmp)
            try? fileManager.createDirectory(atPath: myDirectory, withIntermediateDirectories: true,
                                             attributes: nil)
        } else {
            let userDefaults = UserDefaults.standard
            let keyString = "CocoaDebugNetType"
            userDefaults.set(type, forKey: keyString)
            userDefaults.synchronize()
        }
        if firstSelectNetworkDoneCallBack != nil {
            firstSelectNetworkDoneCallBack!(type)
        } else if switchNetworkDoneCallBack != nil, type != 0 {
            switchNetworkDoneCallBack!(type)
        } else {
            exit(0)
        }
    }

    static func didFinishLaunching(window: UIWindow!,
                                   completionHandler: @escaping SelectFinishNetworkCallBack) {
        // 获取保存到本地的网络类型
        let userDefaults = UserDefaults.standard
        let keyString = "CocoaDebugNetType"
        let netType = userDefaults.integer(forKey: keyString)
        if netType == 0 {
            let viewController = SelectingNetworksViewController()
            viewController.view.backgroundColor = UIColor.black
            viewController.firstSelectNetworkDoneCallBack = { type in
                completionHandler(type)
            }
            window.rootViewController = viewController
        } else {
            completionHandler(1)
        }
    }
}
