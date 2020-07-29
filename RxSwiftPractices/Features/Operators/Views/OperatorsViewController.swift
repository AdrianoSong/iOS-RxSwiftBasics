//
//  OperatorsViewController.swift
//  RxSwiftPractices
//
//  Created by Song on 18/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class OperatorsViewController: UIViewController {

    let bag = DisposeBag()

    fileprivate let hello: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.text = "Look into console for more info"
        view.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Operators Basic"
        view.backgroundColor = .white

        view.addSubview(hello)
        hello.centerYAnchor.constraint(
            equalTo: view.centerYAnchor).isActive = true
        hello.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true

        print("---Example of Ignoring Operator---")
        ignoringOperator()
        print("---Example of ElementAt Operator---")
        elementAtOperator()
        print("---Example of Filter Operator---")
        filterOperator()
        print("---Example of Skip Operator---")
        skipOperator()
        print("---Example of Skip While Operator---")
        skipWhileOperator()
        print("---Example of Skip Until Operator---")
        skipUntil()
        print("---Example of Take Operator---")
        takeOperator()
        print("---Example of Take While Operator---")
        takeWhileOperator()
        print("---Example of Take Until Operator---")
        takeUntilOperator()
        print("---Example of Distinct Operator---")
        distinctOperator()
    }

    fileprivate func ignoringOperator() {

        let strikes = PublishSubject<String>()

        strikes
            .ignoreElements()
            .subscribe { _ in
                print("you are out!!")
            }.disposed(by: bag)

        strikes.onNext("X")
        strikes.onNext("X")
        strikes.onNext("X")

        strikes.onCompleted()
    }

    fileprivate func elementAtOperator() {

        let strikes = PublishSubject<String>()

        strikes
            .elementAt(2)
            .subscribe { event in
                print("2)", event.element ?? event)
                //X3 and completed
            }.disposed(by: bag)

        strikes.onNext("X1")
        strikes.onNext("X2")
        strikes.onNext("X3")
    }

    fileprivate func filterOperator() {

        Observable.of(1, 2, 3, 4, 5).filter { item in
            item % 2 == 0
            }.subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }

    fileprivate func skipOperator() {

        Observable.of("A", "B", "C", "D", "E", "F")
            .skip(3)
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }

    /// Only skips elements up until the first element is let through,
    /// and then all remaining elements are allowed through
    fileprivate func skipWhileOperator() {

        Observable.of(2, 2, 3, 4, 4)
            .skipWhile { item in
                item % 2 == 0 }
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }

    ///What if you want to dynamically filter elements based on some other observable?
    ///This is what skipUntil does
    fileprivate func skipUntil() {

        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()

        subject
            .skipUntil(trigger)
            //it will only print C
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)

        subject.onNext("A")
        subject.onNext("B")

        trigger.onNext("X")

        subject.onNext("C")
    }

    fileprivate func takeOperator() {

        Observable.of(1, 2, 3, 4, 5, 6)
            .take(3) //it will take the first 3 elements
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }

    fileprivate func takeWhileOperator() {

        Observable.of(2, 2, 4, 4, 6, 6)
            .enumerated() //to get a tuple (index and value of array items)
            .takeWhile { index, item in
                item % 2 == 0 && index < 3 }
            .map { $0.element }
            .subscribe(onNext: { print($0) }
        ).disposed(by: bag)
    }

    ///the same as skipUntil but with take
    fileprivate func takeUntilOperator() {

        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()

        subject.takeUntil(trigger)
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)

        subject.onNext("1")
        subject.onNext("2")

        trigger.onNext("X")

        subject.onNext("3")
    }

    fileprivate func distinctOperator() {

        Observable.of("A", "A", "B", "B", "A")
            .distinctUntilChanged() //remove duplicates
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }
}
