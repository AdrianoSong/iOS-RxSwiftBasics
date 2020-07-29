//
//  Coordinator.swift
//  RxSwiftPractices
//
//  Created by Adriano Song on 4/2/20.
//
import UIKit

protocol Coordinator {

    var window: UIWindow? { get set }

    func start()
    func finish()
}
