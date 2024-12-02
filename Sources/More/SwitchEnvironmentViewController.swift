//
//  SwitchEnvironmentViewController.swift
//  CocoaDebug
//
//  Created by 杨波 on 2022/11/26.
//

import UIKit
public typealias SelectFinishNetworkCallBack = (_ type: Int) -> Void

enum SettingEventType: String {
    case production = "正式环境"
    case preProduction = "测试环境"
    case testing = "开发环境"
}

class SwitchCell: UITableViewCell {
    var switchValueChanged: ((Bool) -> Void)?

    var switchControl: UISwitch!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        switchControl = UISwitch()
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

        accessoryView = switchControl
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        switchValueChanged?(sender.isOn)
    }
}

class SwitchEnvironmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    /// 选择环境的回调
    /// 1：生产，2：预生产，3：测试
    var switchNetworkDoneCallBack: ((_ type: Int) -> Void)?

    var currentNetwork: SettingEventType = .production

    @objc var tableHeaderView: UIView? {
        didSet {
            if let tableView = tableView {
                tableView.reloadData()
            }
        }
    }

    private var tableView: UITableView!
    private var settingsData: [String: [CocoaEventModel]] = [:]
    private var sectionTitles: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "More"

        view.backgroundColor = CocoaDebug.mainColor.hexColor

        // 创建UITableView
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.black
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        // 注册UITableViewCell的重用标识符
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")

        tableView.tableHeaderView = tableHeaderView

        let privacySection = "选择接口环境"

        let production = CocoaEventModel()
        production.sectionName = privacySection
        production.titleColor = currentNetwork == .production ? CocoaDebug.mainColor.hexColor : UIColor.white
        production.titleName = currentNetwork == .production ? "当前:\(SettingEventType.production.rawValue)" : SettingEventType.production.rawValue
        production.eventCallBack = { [weak self] in
            self?.switchNetworkDoneCallBack?(1)
        }
        addEventModel(production)

        let preProduction = CocoaEventModel()
        preProduction.sectionName = privacySection
        preProduction.titleColor = currentNetwork == .preProduction ? CocoaDebug.mainColor.hexColor : UIColor.white
        preProduction.titleName = currentNetwork == .preProduction ? "当前:\(SettingEventType.preProduction.rawValue)" : SettingEventType.preProduction.rawValue
        preProduction.eventCallBack = { [weak self] in
            self?.switchNetworkDoneCallBack?(2)
        }
        addEventModel(preProduction)

        let testing = CocoaEventModel()
        testing.sectionName = privacySection
        testing.titleColor = currentNetwork == .testing ? CocoaDebug.mainColor.hexColor : UIColor.white
        testing.titleName = currentNetwork == .testing ? "当前:\(SettingEventType.testing.rawValue)" : SettingEventType.testing.rawValue
        testing.eventCallBack = { [weak self] in
            self?.switchNetworkDoneCallBack?(3)
        }
        addEventModel(testing)

        if sectionTitles.count > 1 {
            let elementToMove = privacySection // 要移动的元素
            if let index = sectionTitles.firstIndex(of: elementToMove) {
                sectionTitles.remove(at: index) // 移除元素
                sectionTitles.insert(elementToMove, at: 0) // 将元素插入到新的位置
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    func addEventModel(_ eventModel: CocoaEventModel) {
        if sectionTitles.contains(eventModel.sectionName) == false {
            sectionTitles.append(eventModel.sectionName)
        }

        if let toolArray = settingsData[eventModel.sectionName] as? [CocoaEventModel], toolArray.count > 0 {
            var toolsArray = toolArray
            toolsArray.append(eventModel)
            settingsData[eventModel.sectionName] = toolsArray
        } else {
            settingsData[eventModel.sectionName] = [eventModel]
        }
        if tableView != nil {
            tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 返回每个分区的标题
        return sectionTitles[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        return settingsData[sectionTitle]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = sectionTitles[indexPath.section]
        if let settingItems = settingsData[sectionTitle] {
            let settingItem = settingItems[indexPath.row]

            switch settingItem.cellType {
            case .switchItem:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                configureSwitchCell(cell, with: settingItem)
                cell.backgroundColor = UIColor.black
                return cell
            case .selectionItem:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
                cell.textLabel?.text = settingItem.titleName
                cell.textLabel?.textColor = settingItem.titleColor
                cell.backgroundColor = UIColor.black
                return cell
            }
        }

        return UITableViewCell()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitle = sectionTitles[indexPath.section]
        if let settingItems = settingsData[sectionTitle] {
            let settingItem = settingItems[indexPath.row]
            // 处理选择项的点击操作
            handleSelectionItemTapped(settingItem)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Cell Configuration

    private func configureSwitchCell(_ cell: SwitchCell, with toolModel: CocoaEventModel) {
        cell.textLabel?.text = toolModel.titleName
        cell.textLabel?.textColor = toolModel.titleColor

        cell.switchControl.isOn = toolModel.isSwitchOn
        cell.switchValueChanged = { [weak self] isOn in
            toolModel.isSwitchOn = isOn
            toolModel.switchEventCallBack?()
        }
    }

    // MARK: - Event处理

    private func handleSelectionItemTapped(_ toolModel: CocoaEventModel) {
        toolModel.eventCallBack?()
    }
}
