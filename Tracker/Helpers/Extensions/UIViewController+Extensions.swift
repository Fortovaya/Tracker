//
//  UIViewController+Extensions.swift
//  Tracker
//
//  Created by Алина on 12.06.2025.
//

import UIKit

extension UIViewController {
    func presentPageSheet( viewController: UIViewController, animated: Bool = true,
        transitionStyle: UIModalTransitionStyle = .coverVertical
    ) {
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .pageSheet
        nav.modalTransitionStyle   = transitionStyle
        present(nav, animated: animated)
    }
}
