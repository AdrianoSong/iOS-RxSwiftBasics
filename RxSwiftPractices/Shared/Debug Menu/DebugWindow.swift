//
//  DebugWindow.swift
//  RxSwiftPractices
//
//  Created by Adriano Song on 4/2/20.
//

import UIKit

class DebugWindow: UIWindow {

    var appCoordinator: AppCoordinator?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentDebug))
        tapGestureRecognizer.numberOfTouchesRequired = 2

        self.addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    @objc func presentDebug() {
        guard let controller = topViewController(),
            let appCoordinator = self.appCoordinator else { return }

        let debugController = DebugMenuViewController(appCoordinator)
        let nav = UINavigationController(rootViewController: debugController)
        controller.present(nav, animated: true, completion: nil)
    }

    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
