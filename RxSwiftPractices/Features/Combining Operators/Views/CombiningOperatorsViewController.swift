//
//  CombiningOperatorsViewController.swift
//  RxSwiftPractices
//
//  Created by Song on 20/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class CombiningOperatorsViewController: UIViewController {

    enum Weather {
        case cloudy
        case sunny
    }

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

        title = "Combining Operators Basics"
        view.backgroundColor = .white

        view.addSubview(hello)
        hello.centerYAnchor.constraint(
            equalTo: view.centerYAnchor).isActive = true
        hello.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true

        print("---Example of startWith---")
        startWith()
        print("---Example of concat 1---")
        concat1()
        print("---Example of concat 2---")
        concat2()
        print("---Example of concatMap---")
        concatMap()
        print("---Example of Merge---")
        merge()
        print("---Example of combineLatest---")
        combineLatest()
        print("---Example of zip---")
        zip()
        print("---Example of withLatestFrom---")
        withLatestFrom()
        print("---Example of amb---")
        amb()
        print("---Example of switchLatest---")
        switchLatest()
        print("---Example of reduce---")
        reduce()
        print("---Example of scan---")
        scan()
    }

    ///prefixes an observable with initial value
    fileprivate func startWith() {

        let numbers = Observable.of(2, 3, 4)

        let observable = numbers.startWith(1)

        observable.subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }

    ///concat will chain collection of observables
    fileprivate func concat1() {
        let first = Observable.of(1, 2, 3)
        let second = Observable.of(4, 5, 6)

        let observable = Observable.concat([first, second])

        observable.subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }

    ///concat will chain collection of observables
    fileprivate func concat2() {
        let germanCities = Observable.of("Berlin", "Munich", "Frankfurt")
        let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")

        let observable = germanCities.concat(spanishCities)

        observable.subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }

    ///concatMap is closely related to flapMap, it will map sequences into only one
    fileprivate func concatMap() {
        let sequences = [
            "Germany": Observable.of("Berlin", "Munich", "Frankfurt"),
            "Spain": Observable.of("Madrid", "Barcelona", "Valencia")
        ]

        let observable = Observable.of("Germany", "Spain").concatMap { country in
            sequences[country] ?? .empty()
        }

        observable.subscribe(onNext: {print($0)}).disposed(by: bag)
    }

    ///merge() observable subscribe to each of the sequences it receives and emmits
    ///the elements as soon as they arrive - there's no predefine order.
    fileprivate func merge() {

        let left = PublishSubject<String>()
        let right = PublishSubject<String>()

        let source = Observable.of(left.asObservable(), right.asObservable())

        let observable = source.merge()

        let disposable = observable.subscribe(onNext: {print($0)})

        var leftValues = ["Berlin", "Munich", "Frankfurt"]

        var rightValue = ["Madrid", "Barcelona", "Valencia"]

        repeat {
            if arc4random_uniform(2) == 0 {
                if !leftValues.isEmpty {
                    left.onNext("Left: " + leftValues.removeFirst())
                }
            } else if !rightValue.isEmpty {
                right.onNext("Right: " + rightValue.removeFirst())
            }
        } while !leftValues.isEmpty || !rightValue.isEmpty

        disposable.dispose()
    }

    ///CombineLatest wait for the latest emit values from any subject to combine them
    fileprivate func combineLatest() {

        let left = PublishSubject<String>()
        let right = PublishSubject<String>()

        let observable = Observable.combineLatest(
            left, right, resultSelector: { lastLeft, lastRight in
                return "\(lastLeft) \(lastRight)"
        })

        let disposable = observable.subscribe(onNext: {print($0)})

        print("> Seding a value to Left")
        left.onNext("Hello,")
        print("> Seding a value to Right")
        right.onNext("world")
        print("> Seding anothre value to Right")
        right.onNext("RxSwfit")
        print("> Seding another value to Left")
        left.onNext("Have a good day.")

        disposable.dispose()
    }

    ///zip is is always wait for both sides emit a new value to call its closure
    ///OBS: Vienna is missing because there is no weather to match with it
    fileprivate func zip() {

        let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
        let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")

        let observable = Observable.zip(left, right) { weather, city in
            return "It's \(weather) in \(city)"
        }

        observable.subscribe(onNext: {print($0)}).disposed(by: bag)
    }

    fileprivate func withLatestFrom() {
        let button = PublishSubject<Void>()
        let textField = PublishSubject<String>()

        let observable = button.withLatestFrom(textField)
        _ = observable.subscribe(onNext: {print($0)})

        textField.onNext("Par")
        textField.onNext("Pari")
        textField.onNext("Paris")

        button.onNext(())
        button.onNext(())
    }

    ///Think of "amb" as in "ambiguous"
    fileprivate func amb() {
        let left = PublishSubject<String>()
        let right = PublishSubject<String>()

        let observable = left.amb(right)

        let disposable = observable.subscribe(onNext: {print($0)})

        left.onNext("Lisbon")
        right.onNext("Copenhagen")
        left.onNext("London")
        left.onNext("Madrid")
        right.onNext("Vienna")

        disposable.dispose()
    }

    ///switchLatest will show only items from latest sequence pushed to the "source" observable
    fileprivate func switchLatest() {
        let one = PublishSubject<String>()
        let two = PublishSubject<String>()
        let three = PublishSubject<String>()

        let source = PublishSubject<Observable<String>>()

        let observable = source.switchLatest()
        let disposable = observable.subscribe(onNext: {print($0)})

        source.onNext(one)

        one.onNext("Some text from sequence one")
        two.onNext("Some text from sequence two")

        source.onNext(two)
        two.onNext("Why don't you see me?")
        one.onNext("I'm alone, help me")
        three.onNext("Hey it's three. I win.")

        source.onNext(one)

        one.onNext("Nope, It's me, one!")

        disposable.dispose()
    }

    ///just like reduce() in standard library
    fileprivate func reduce() {
        let source = Observable.of(1, 3, 5, 7, 9)

        let observable = source.reduce(0, accumulator: +)
        //you can do the same as here:
//        let observable = source.reduce(0, accumulator: { summary, newValue in
//            return summary + newValue
//        })

        observable.subscribe(onNext: {print($0)}).disposed(by: bag)
    }

    ///you can use scan to compute running totals, you don't need to use a local var,
    ///and its goes away when the source observale completes.
    fileprivate func scan() {
        let source = Observable.of(1, 3, 5, 7, 9)

        let observable = source.scan(0, accumulator: +)

        observable.subscribe(onNext: {print($0)}).disposed(by: bag)
    }
}
