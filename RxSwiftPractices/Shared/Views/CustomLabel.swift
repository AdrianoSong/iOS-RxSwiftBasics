//
//  CustomLabel.swift
//  RxSwiftPractices
//
//  Created by Song on 25/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import Foundation
import UIKit

class CustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        textColor = .white
        backgroundColor = .red
        layer.cornerRadius = 5
        layer.masksToBounds = true
        numberOfLines = 0
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 24, weight: .regular)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
