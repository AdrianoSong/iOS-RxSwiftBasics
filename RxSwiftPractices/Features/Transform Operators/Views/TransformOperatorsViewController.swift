//
//  TransformOperatorsViewController.swift
//  RxSwiftPractices
//
//  Created by Song on 20/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TransformOperatorsViewController: UIViewController {

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

        title = "Transform Operators Basics"
        view.backgroundColor = .white

        view.addSubview(hello)
        hello.centerYAnchor.constraint(
            equalTo: view.centerYAnchor).isActive = true
        hello.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true

        print("---Example toArray---")
        toArray()
        print("---Example of map---")
        map()
        print("---Example of enumerated---")
        enumerated()
        print("---Example of flatMap---")
        flatMap()
        print("---Example of flatMapLatest---")
        flatMapLatest()
        print("---Example of Materialized and Dematerialized")
        materializeAndDematerialize()
    }

    ///transform all elements into an array
    fileprivate func toArray() {

        Observable.of("A", "B", "C")
            .toArray()
            .subscribe({print($0)}
        ).disposed(by: bag)
    }

    ///RXSwift map is the same as map of standard library except it operates on observables
    fileprivate func map() {

        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut

        Observable<NSNumber>.of(123, 4, 56)
            .map {formatter.string(from: $0) ?? ""}
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }

    ///Remember enumerated() produce a tuple of index and value of each element
    fileprivate func enumerated() {

        Observable.of(1, 2, 3, 4, 5, 6)
            .enumerated()
            .map {index, value in
                index > 2 ? value * 2 : value
            }.subscribe(onNext: {print($0)}
        ).disposed(by: bag)
    }

    ///flatMap keeps projecting changes from each observables.
    ///There will be times when you want this behavior.
    fileprivate func flatMap() {
        let ryan = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 90))

        let student = PublishSubject<Student>()

        student.flatMap { $0.score }
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)

        //1
        student.onNext(ryan)
        //2
        ryan.score.onNext(85)
        //3
        student.onNext(charlotte)
        //4
        ryan.score.onNext(95)
        //5
        charlotte.score.onNext(100)
    }

    ///its almost the same as flatMap() with one different here:
    ///When changing Ryan's score(step 4) will have no effect because
    ///flatMapLatest has already switched to the latest observable (charlotte)
    ///OBS: THIS IS A GOOD OPERATOR FOR NETWORKING
    fileprivate func flatMapLatest() {
        let ryan = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 90))

        let student = PublishSubject<Student>()

        student.flatMapLatest { $0.score }
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)

        //1
        student.onNext(ryan)
        //2
        ryan.score.onNext(85)
        //3
        student.onNext(charlotte)
        //4
        ryan.score.onNext(95)
        //5
        charlotte.score.onNext(100)
    }

    ///Using materlize() operator, you can wrap each event emitted by an observable in an observable
    fileprivate func materializeAndDematerialize() {
        let ryan = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 90))

        let student = BehaviorSubject(value: ryan)

        let studentScore = student.flatMapLatest {
            $0.score.materialize()//Observable<Event<Int>>
        }

        //this will you will handle the event not the elements (because materialize operator)
        //studentScore.subscribe(onNext: {print($0)}).disposed(by: bag)

        studentScore
            .filter {
                guard $0.error == nil else {
                    print($0.error!)
                    return false
                }
                return true
            }
            .dematerialize() // convert materialized observables into original form
            .subscribe(onNext: {print($0)}
        ).disposed(by: bag)

        ryan.score.onNext(85)

        ryan.score.onError(MyError.anError)

        ryan.score.onNext(90)

        student.onNext(charlotte)
    }
}
