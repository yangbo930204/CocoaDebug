//
//  MoreViewController.swift
//  Pods
//
//  Created by YangBo on 2022/3/23.
//

import UIKit

public typealias SelectFinishNetworkCallBack = () -> Void

class MoreViewController: UIViewController {
    /// 首次选择完成环境的回调
    var firstSelectNetworkDoneCallBack: (() -> Void)?

    var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 290))
//        bgView.backgroundColor = UIColor.red
        view.addSubview(bgView)
        
        // 获取保存到本地的网络类型
        let userDefaults = UserDefaults.standard
        let keyString = "CocoaDebugNetType"
        let netType = userDefaults.integer(forKey: keyString)
        
        let currentNetworkLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        currentNetworkLabel.textAlignment = .center
        switch netType {
        case 1:
            currentNetworkLabel.text = "当前：开发环境"
        case 2:
            currentNetworkLabel.text = "当前：测试环境"
        case 3:
            currentNetworkLabel.text = "当前：正式环境"
        default:
            currentNetworkLabel.text = "第一次启动：请选择默认环境"
            break
        }
        
        currentNetworkLabel.textColor = UIColor.white
        bgView.addSubview(currentNetworkLabel)
        
        let color: String = "#7B94CD"
        let cutNetworkDeveloperButton = UIButton(type: .custom)
        cutNetworkDeveloperButton.frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: 50)
        cutNetworkDeveloperButton.setTitle("开发环境", for: UIControl.State.normal)
        cutNetworkDeveloperButton.addTarget(self, action: #selector(developerButtonAction), for: UIControl.Event.touchUpInside)
        cutNetworkDeveloperButton.backgroundColor = color.hexColor
        bgView.addSubview(cutNetworkDeveloperButton)

        let cutNetworkTextButton = UIButton(type: .custom)
        cutNetworkTextButton.frame = CGRect(x: 0, y: 120, width: self.view.frame.size.width, height: 50)
        cutNetworkTextButton.setTitle("测试环境", for: UIControl.State.normal)
        cutNetworkTextButton.backgroundColor = color.hexColor
        cutNetworkTextButton.addTarget(self, action: #selector(cutNetworkTextButtonAction), for: UIControl.Event.touchUpInside)
        bgView.addSubview(cutNetworkTextButton)
        
        let cutNetworkButton = UIButton(type: .custom)
        cutNetworkButton.frame = CGRect(x: 0, y: 180, width: self.view.frame.size.width, height: 50)
        cutNetworkButton.setTitle("正式环境", for: UIControl.State.normal)
        cutNetworkButton.backgroundColor = color.hexColor
        cutNetworkButton.addTarget(self, action: #selector(cutNetworkButtonAction), for: UIControl.Event.touchUpInside)
        bgView.addSubview(cutNetworkButton)
        
        if netType != 0 {
            let clearDataButton = UIButton(type: .custom)
            clearDataButton.frame = CGRect(x: 0, y: 240, width: self.view.frame.size.width, height: 50)
            clearDataButton.setTitle("清除所有数据（相当于卸载重装）", for: UIControl.State.normal)
            clearDataButton.backgroundColor = color.hexColor
            clearDataButton.addTarget(self, action: #selector(clearDataButtonAction), for: UIControl.Event.touchUpInside)
            bgView.addSubview(clearDataButton)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.center = CGPoint(x: self.view.bounds.width * 0.5, y: self.view.bounds.height * 0.5)
    }
    
    @objc func developerButtonAction() {
        self.switchingNetwork(1)
    }
    
    @objc func cutNetworkTextButtonAction() {
        self.switchingNetwork(2)
    }
    
    @objc func cutNetworkButtonAction() {
        self.switchingNetwork(3)
    }
    
    @objc func clearDataButtonAction() {
        self.switchingNetwork(0)
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
            firstSelectNetworkDoneCallBack!()
        } else {
            exit(0)
        }
    }

    static func didFinishLaunching(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
                                   window: UIWindow!,
                                   completionHandler: @escaping SelectFinishNetworkCallBack) {
        // 获取保存到本地的网络类型
        let userDefaults = UserDefaults.standard
        let keyString = "CocoaDebugNetType"
        let netType = userDefaults.integer(forKey: keyString)
        if netType == 0 {
            let viewController = MoreViewController()
            viewController.view.backgroundColor = UIColor.black
            viewController.firstSelectNetworkDoneCallBack = {
                completionHandler()
            }
            window.rootViewController = viewController
        } else {
            completionHandler()
        }
    }
}
