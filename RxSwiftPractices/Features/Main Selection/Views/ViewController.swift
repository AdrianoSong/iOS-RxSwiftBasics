//
//  ViewController.swift
//  RxSwiftPractices
//
//  Created by Song on 14/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let viewModel = VCViewModel()

    fileprivate let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var finish: ((MainChoice) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "RxSwift Basics"
        view.backgroundColor = .white

        setupTableView()
    }

    fileprivate func setupTableView() {
        // Do any additional setup after loading the view.
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        tableView.dataSource = self
        tableView.delegate = self

        viewModel.choiceArray.forEach { item in
            switch item {
            case .simpleCell(_, let identifier, _, _):
                tableView.register(CellType1.self, forCellReuseIdentifier: identifier)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.choiceArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.choiceArray[indexPath.row] {
        case .simpleCell(let title, _, _, _):
            let cell = CellType1()
            cell.updateTitle = title
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.choiceArray[indexPath.row] {
        case .simpleCell(_, _, let size, _):
            return size
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.choiceArray[indexPath.row] {
        case .simpleCell(_, _, _, let choice):
            finish?(choice)
        }
    }
}
