//
//  SubjectsViewController.swift
//  RxSwiftPractices
//
//  Created by Song on 15/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class SubjectsViewController: UIViewController {

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

        title = "Subject basics"
        view.backgroundColor = .white

        view.addSubview(hello)
        hello.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hello.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        print("---Example of PublishSubject---")
        publishSubject()

        print("---Example of BehaviorSubject---")
        behaviorSubject()

        print("---Example 1 of BehaviorRelay---")
        behaviorRelayExample1()

        print("---Example 2 of BehaviorRelay---")
        behaviorRelayExample2()
    }

    ///What is a Subject? Subjects act as both an observable and observer
    ///It can receive events and also be subscribed to.
    fileprivate func publishSubject() {

        let subject = PublishSubject<String>()
        subject.onNext("Is anyone listening?")

        _ = subject.subscribe(onNext: {string in
            print("receive value: \(string)")
        }).disposed(by: bag)

        //will emit a new value (2x declarations have the same effect)
        subject.on(.next("1"))
        subject.onNext("2")

        _ = subject.subscribe { event in
            print("2)", event.element ?? event)
        }.disposed(by: bag)

        subject.onNext("3")
    }

    /// common use a subject with has a init value
    fileprivate func behaviorSubject() {

        let behaviorSubject = BehaviorSubject(value: "Initial value")

        behaviorSubject.subscribe { event in
            print("2)", event.element ?? event)
        }.disposed(by: bag)

        behaviorSubject.onNext("X")
    }

    ///the new version of Variable its a wrapper for BehaviorSbuject, its from RxCocoa to wrap view values
    fileprivate func behaviorRelayExample1() {

        let newVariable = BehaviorRelay<String>(value: "Initial value")

        newVariable.accept("new value")

        newVariable.asObservable().subscribe { event in
            print("2)", event.element ?? event)
        }.disposed(by: bag)
    }

    /// behaviorRelay will never emit an error,
    /// as you can see every time you emit new value it will be catched by asObservable().subscribe() method,
    /// this is great to bind views to interact with new values
    fileprivate func behaviorRelayExample2() {

        let newVariable = BehaviorRelay<String>(value: "Initial value")

        newVariable.asObservable().subscribe { event in
            print("2)", event.element ?? event)
        }.disposed(by: bag)

        newVariable.accept("new value")
    }
}
