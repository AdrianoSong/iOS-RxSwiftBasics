//
//  RxGesturesViewController.swift
//  RxSwiftPractices
//
//  Created by Song on 25/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxGesture

class RxGesturesViewController: UIViewController {

    let bag = DisposeBag()

    fileprivate let hello: CustomLabel = {
        return CustomLabel()
    }()

    fileprivate let tapAndLongPress: CustomLabel = {
        return CustomLabel()
    }()

    fileprivate let screenEdgePanGesture: CustomLabel = {
        return CustomLabel()
    }()

    fileprivate let locationInWindow: CustomLabel = {
        return CustomLabel()
    }()

    fileprivate let rotationGesture: CustomLabel = {
        return CustomLabel()
    }()

    fileprivate let transformGesture: CustomLabel = {
        return CustomLabel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "RxGestures Basics"
        view.backgroundColor = .white

        setupHelloLabel()
        setupTapAndLongPressLabel()
        setupScreenEdgePanGestureLabel()
        setupLocationInWindowLabel()
        setupRotationGestureLabel()
        setupTransformGestureLabel()

        bindHelloLabel()
        bindTapAndLongPressLabel()
        bindScreenEdgePanGesture()
        bindLocationInWindowLabel()
        bindRotationGestureLabel()
        bindTransformGestureLabel()
    }

    // MARK: - Setup views
    fileprivate func setupHelloLabel() {
        view.addSubview(hello)
        hello.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        hello.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 20).isActive = true
        hello.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -20).isActive = true

        hello.text = "tap me!"
    }

    fileprivate func setupTapAndLongPressLabel() {
        view.addSubview(tapAndLongPress)
        tapAndLongPress.topAnchor.constraint(
            equalTo: hello.bottomAnchor, constant: 20).isActive = true
        tapAndLongPress.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 20).isActive = true
        tapAndLongPress.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -20).isActive = true

        tapAndLongPress.text = "Tap and Long Press me!"
    }

    fileprivate func setupScreenEdgePanGestureLabel() {
        view.addSubview(screenEdgePanGesture)
        screenEdgePanGesture.topAnchor.constraint(
            equalTo: tapAndLongPress.bottomAnchor, constant: 20).isActive = true
        screenEdgePanGesture.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 20).isActive = true
        screenEdgePanGesture.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -20).isActive = true

        screenEdgePanGesture.text = "Gesture on me!"
    }

    fileprivate func setupLocationInWindowLabel() {
        view.addSubview(locationInWindow)
        locationInWindow.topAnchor.constraint(
            equalTo: screenEdgePanGesture.bottomAnchor, constant: 20).isActive = true
        locationInWindow.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 20).isActive = true
        locationInWindow.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -20).isActive = true

        locationInWindow.text = "tap on me to find location in window!"
    }

    fileprivate func setupRotationGestureLabel() {
        view.addSubview(rotationGesture)
        rotationGesture.topAnchor.constraint(
            equalTo: locationInWindow.bottomAnchor, constant: 20).isActive = true
        rotationGesture.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 20).isActive = true
        rotationGesture.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -20).isActive = true

        rotationGesture.text = "rotate me please!"
    }

    fileprivate func setupTransformGestureLabel() {
        view.addSubview(transformGesture)
        transformGesture.topAnchor.constraint(
            equalTo: rotationGesture.bottomAnchor, constant: 20).isActive = true
        transformGesture.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 20).isActive = true
        transformGesture.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -20).isActive = true

        transformGesture.text = "transform me!"
    }

    // MARK: - Bind views
    fileprivate func bindHelloLabel() {
        hello.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                print("tapped 👏")
            }
        ).disposed(by: bag)
    }

    fileprivate func bindTapAndLongPressLabel() {
        tapAndLongPress.rx.anyGesture(.tap(), .longPress())
            .when(.recognized)
            .subscribe(onNext: {[weak tapAndLongPress] gesture in
                if let tap = gesture as? UITapGestureRecognizer {
                    print("It's a tap 👏 \(tap.location(in: tapAndLongPress))")
                } else {
                    print("It's was a long press")
                }
                }
        ).disposed(by: bag)
    }

    fileprivate func bindScreenEdgePanGesture() {
        screenEdgePanGesture.rx.anyGesture(.screenEdgePan())
            .when(.recognized)
            .subscribe(onNext: { gesture in
                print("gesture was recognized \(gesture.name ?? "")")
            }
        ).disposed(by: bag)
    }

    fileprivate func bindLocationInWindowLabel() {
        locationInWindow.rx.tapGesture()
            .when(.recognized)
            .asLocation(in: .superview)
            .subscribe(onNext: { location in
                print("tapped 👏 at: \(location) superview location")
            }
        ).disposed(by: bag)
    }

    fileprivate func bindRotationGestureLabel() {
        rotationGesture.rx.rotationGesture()
            .asRotation()
            .subscribe(onNext: { rotation, velocity in
                print("rotation=\(rotation), velocity: \(velocity)")
            }
        ).disposed(by: bag)
    }

    /// transformGesture() is a convenience extension which creates three gestures:
    /// pan, pinch and rotation - attaches them to a view and returns an
    /// Observable<TransformGestureRecognizer>.
    /// The TransformGestureRecognizer struct simply holds the three recognizers.
    /// asTransform() operator turns the structure into an
    /// Observable<(transform: CGAffineTransform, velocity: TransformVelocity)>.
    /// TransformVelocity holds the individual velocity of each gesture
    fileprivate func bindTransformGestureLabel() {
        transformGesture.rx.transformGestures()
            .asTransform()
            .subscribe(onNext: { [weak self] (transform, velocity) in
                print("in velocity \(velocity)")
                self?.transformGesture.transform = transform
                }
        ).disposed(by: bag)

        //how to get specific gesture
        /**
            view.rx.transformGestures(configuration: { (recognizer, delegate) in
                recognizer.pinchGesture.isEnabled = false
            })
         */
    }
}
