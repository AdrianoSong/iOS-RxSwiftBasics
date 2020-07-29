//
//  Coordinator.swift
//  RxSwiftPractices
//
//  Created by Adriano Song on 4/2/20.
//
import UIKit

class AppCoordinator: Coordinator {

    var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let viewController = ViewController()
        let navigation = UINavigationController()

        navigation.viewControllers = [viewController]

        viewController.finish = { choice in
            switch choice {
            case .observable:
                navigation.pushViewController(ObservableViewController(), animated: true)
            case .subjects:
                navigation.pushViewController(SubjectsViewController(), animated: true)
            case .operators:
                navigation.pushViewController(OperatorsViewController(), animated: true)
            case .transformOperators:
                navigation.pushViewController(TransformOperatorsViewController(), animated: true)
            case .combiningOperators:
                navigation.pushViewController(CombiningOperatorsViewController(), animated: true)
            case .rxGestures:
                navigation.pushViewController(RxGesturesViewController(), animated: true)
            }
        }

        window?.rootViewController = navigation
    }

    func finish() {  }
}
