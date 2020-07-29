//
//  ObservableViewController.swift
//  RxSwiftPractices
//
//  Created by Song on 15/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ObservableViewController: UIViewController {

    var observable1: Observable<Int>?
    var observableRange: Observable<Int>?

    let bag = DisposeBag()

    fileprivate let screenTitle: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.numberOfLines = 0
        view.text = "Look into console for more info"
        view.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreen()
        print("----Example of declaration----")
        observableDeclaration()
        print("----Example of subscribe----")
        subscribingAnObservable()
        print("----Example of create----")
        createAnObservable()
    }

    fileprivate func setupScreen() {
        title = "Observable basics"
        view.backgroundColor = .white

        view.addSubview(screenTitle)
        screenTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    fileprivate func observableDeclaration() {
        let one = 1
        let two = 2
        let three = 3

        //observable of 1 value
        observable1 = Observable<Int>.just(one)
        //observable of variadic values (like array)
        _ = Observable.of(one, two, three)
        //observable of array values
        _ = Observable.of([one, two, three])
        //observable of individual type instances from a regular array of elements
        _ = Observable.from([one, two, three])
        //observable range of values
        observableRange = Observable<Int>.range(start: 1, count: 10)
    }

    fileprivate func subscribingAnObservable() {

        _ = observable1?.subscribe { event in
            print(event) // print next event
            if let element = event.element {
                print(element) // print element from event
            }
        }

        //its the same from above but with more options (like onError, onComplete)
        //OBS: using debug help for complex rx chaining
        _ = observable1?.debug().subscribe(onNext: { element in
            print("sucess \(element)")
        }, onError: { error in
            print("error \(error)")
        }, onCompleted: {
            print("complete")
        })

        observableRange?.subscribe(onNext: {element in

            let toDouble = Double(element)
            let fibonacci = Int(((pow(1.61803, toDouble) - pow(0.61803, toDouble) / 2.23606).rounded()))
            print("fibo: \(fibonacci)")

        }).disposed(by: bag)
    }

    fileprivate func createAnObservable() {

        let creatingOfCustomObservable = Observable<String>.create { observer in

            observer.onNext("1")

            //create error example
            //observer.onError(MyError.anError)

            observer.onCompleted()

            observer.onNext("?")

            return Disposables.create()
        }

        creatingOfCustomObservable.subscribe(
            onNext: {print($0)},
            onError: { print($0)},
            onCompleted: {print("Completed")},
            onDisposed: {print("Disposed")}
        ).disposed(by: bag)
    }
}
