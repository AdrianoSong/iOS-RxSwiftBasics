//
//  CellType1.swift
//  RxSwiftPractices
//
//  Created by Song on 14/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import Foundation
import UIKit

class CellType1: UITableViewCell {

    fileprivate let title: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var updateTitle: String? {
        didSet {
            title.text = updateTitle
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(title)
        title.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
