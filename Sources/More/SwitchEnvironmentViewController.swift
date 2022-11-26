//
//  SwitchEnvironmentViewController.swift
//  CocoaDebug
//
//  Created by 杨波 on 2022/11/26.
//

import UIKit

class SwitchEnvironmentViewController: UIViewController {
    /// 选择环境的回调
    /// 1：生产，2：预生产，3：测试
    var switchNetworkDoneCallBack: ((_ type: Int) -> Void)?
    var currentNetworkLabel: UILabel!
    var currentNetworkString: String = ""

    var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Environment Switch"

        bgView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 152))
        view.addSubview(bgView)

        // 获取保存到本地的网络类型
        let color: UIColor = UIColor.black
        let backgroundColor: UIColor = "#FFFC14".hexColor

        currentNetworkLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        currentNetworkLabel.textAlignment = .center
        currentNetworkLabel.textColor = backgroundColor
        currentNetworkLabel.text = currentNetworkString
        currentNetworkLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(currentNetworkLabel)

        let cutNetworkDeveloperButton = UIButton(type: .custom)
        cutNetworkDeveloperButton.frame = CGRect(x: 14, y: 0, width: view.frame.size.width - 28, height: 44)
        cutNetworkDeveloperButton.setTitle("Production Environment（生产环境）", for: UIControl.State.normal)
        cutNetworkDeveloperButton.addTarget(self, action: #selector(productionButtonAction), for: UIControl.Event.touchUpInside)
        cutNetworkDeveloperButton.setTitleColor(color, for: UIControl.State.normal)
        cutNetworkDeveloperButton.backgroundColor = backgroundColor
        cutNetworkDeveloperButton.layer.masksToBounds = true
        cutNetworkDeveloperButton.layer.cornerRadius = 4
        bgView.addSubview(cutNetworkDeveloperButton)

        let cutNetworkTextButton = UIButton(type: .custom)
        cutNetworkTextButton.frame = CGRect(x: cutNetworkDeveloperButton.frame.origin.x, y: 54,
                                            width: cutNetworkDeveloperButton.frame.size.width, height: 44)
        cutNetworkTextButton.setTitle("Pre Production Environment（预生产环境）", for: UIControl.State.normal)
        cutNetworkTextButton.setTitleColor(color, for: UIControl.State.normal)
        cutNetworkTextButton.addTarget(self, action: #selector(grayscaleButtonAction), for: UIControl.Event.touchUpInside)
        cutNetworkTextButton.backgroundColor = backgroundColor
        cutNetworkTextButton.layer.masksToBounds = true
        cutNetworkTextButton.layer.cornerRadius = 4
        bgView.addSubview(cutNetworkTextButton)

        let cutNetworkButton = UIButton(type: .custom)
        cutNetworkButton.frame = CGRect(x: cutNetworkDeveloperButton.frame.origin.x, y: 108,
                                        width: cutNetworkDeveloperButton.frame.size.width, height: 44)
        cutNetworkButton.setTitle("Testing Environment（测试环境）", for: UIControl.State.normal)
        cutNetworkButton.setTitleColor(color, for: UIControl.State.normal)
        cutNetworkButton.addTarget(self, action: #selector(testButtonAction), for: UIControl.Event.touchUpInside)
        cutNetworkButton.backgroundColor = backgroundColor
        cutNetworkButton.layer.masksToBounds = true
        cutNetworkButton.layer.cornerRadius = 4
        bgView.addSubview(cutNetworkButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.center = CGPoint(x: view.bounds.width * 0.5, y: view.bounds.height * 0.5)

        currentNetworkLabel.frame = CGRect(x: 0, y: bgView.frame.origin.y - 84, width: view.frame.size.width, height: 44)
    }

    @objc func productionButtonAction(_ sender: UIButton) {
        switchNetworkDoneCallBack?(1)
    }

    @objc func grayscaleButtonAction(_ sender: UIButton) {
        switchNetworkDoneCallBack?(2)
    }

    @objc func testButtonAction(_ sender: UIButton) {
        switchNetworkDoneCallBack?(3)
    }
}
