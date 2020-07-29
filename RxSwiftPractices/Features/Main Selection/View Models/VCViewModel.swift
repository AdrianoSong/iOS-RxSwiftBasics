//
//  Coordinator.swift
//  RxSwiftPractices
//
//  Created by Adriano Song on 4/2/20.
//

import Foundation
import UIKit
//import RxSwift

enum MainChoice {
    case observable
    case subjects
    case operators
    case transformOperators
    case combiningOperators
    case rxGestures
}

enum MainChoicesCell {

    case simpleCell (title: String, identifier: String, cellHeight: CGFloat, choice: MainChoice)
}

class VCViewModel {

    let choiceArray: [MainChoicesCell]

    init() {
        choiceArray = [.simpleCell(
            title: "Observable basics",
            identifier: "cellType1",
            cellHeight: 50, choice: .observable),
            .simpleCell(
            title: "Subjects basics",
            identifier: "cellType1",
            cellHeight: 50, choice: .subjects),
            .simpleCell(
            title: "Operators basics",
            identifier: "cellType1",
            cellHeight: 50, choice: .operators),
            .simpleCell(
            title: "Transform Operators basics",
            identifier: "cellType1",
            cellHeight: 50, choice: .transformOperators),
            .simpleCell(
            title: "Combining Operators basics",
            identifier: "cellType1",
            cellHeight: 50, choice: .combiningOperators),
            .simpleCell(
            title: "RxGestures",
            identifier: "cellType1",
            cellHeight: 50, choice: .rxGestures)

        ]
    }

    func sayHello() -> String {
        return NSLocalizedString("hello.world", comment: "")
    }

    ///Example how to use Api layer
//    func getUser(email: String, password: String) -> Observable<UserElement> {
//        return BaseApi.request(urlConvertile: ApiRouter.getUser(email: email, password: password))
//    }
}
