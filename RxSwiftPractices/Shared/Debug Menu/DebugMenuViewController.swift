//
//  DebugMenuViewController.swift
//  RxSwiftPractices
//
//  Created by Adriano Song on 4/2/20.
//

import UIKit

class DebugMenuViewController: UIViewController {

    enum DebugOptions: String, CaseIterable {
        case buildVersion = "Build version: %@"
    }

    let appCoordinator: AppCoordinator
    let userDefaults = UserDefaults.standard

    fileprivate let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()

    init(_ appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Debug Menu"

        view.backgroundColor = .white
        prepareView()
    }

    fileprivate func prepareView() {
        prepareCloseButton()
        prepareTableView()
    }

    fileprivate func prepareTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    fileprivate func prepareCloseButton() {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .done,
            target: self,
            action: #selector(close)
        )
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
}

// MARK: - Methods
extension DebugMenuViewController {

    @objc
    fileprivate func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DebugMenuViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DebugOptions.allCases.count
    }

    func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }

        let item = DebugOptions.allCases[indexPath.row]

        return configureCell(item, cell)
    }

    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    fileprivate func configureCell(
        _ item: DebugMenuViewController.DebugOptions, _ cell: UITableViewCell) -> UITableViewCell {

        switch item {
        case .buildVersion:
            return configureBuildVersionCell(item: item, cell: cell)
        }
    }

    fileprivate func configureBuildVersionCell(
        item: DebugMenuViewController.DebugOptions, cell: UITableViewCell) -> UITableViewCell {
        let bundleVersion =
            "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")" +
            " - \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "")"

        cell.accessoryType = .none
        cell.textLabel?.text = String(format: item.rawValue, bundleVersion)

        return cell
    }
}

extension DebugMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let option = DebugOptions.allCases[indexPath.row]

        print("Item selected \(option)")

        //Here you send user to your debug screen (ex: DebugOnboardingViewController(appCoordinator: appCoordinator))
    }
}
