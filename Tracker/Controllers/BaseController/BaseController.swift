//
//  BaseController.swift
//  Tracker
//
//  Created by Алина on 01.05.2025.
//
import UIKit

class BaseController: UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureViewController()
    }
    
    private func configureViewController(){
        view.backgroundColor = .ypWhite
        hideKeyboardWhenTappedAround()
    }
    
    final func setCenteredInlineTitle(
        title text: Resources.ScreenTitles,
        font: UIFont = .systemFont(ofSize: 16, weight: .medium),
        color: UIColor = .ypBlack
    ) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        let label = UILabel()
        label.text = text.text
        label.font = font
        label.textColor = color
        label.textAlignment = .center
        
        navigationItem.titleView = label
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    final func presentPageSheet(
        viewController: UIViewController,
        animated: Bool = true,
        transitionStyle: UIModalTransitionStyle = .coverVertical
    ) {
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .pageSheet
        nav.modalTransitionStyle   = transitionStyle
        present(nav, animated: animated)
    }
    
    final func dismissToRootModal(animated: Bool = true, completion: (() -> Void)? = nil) {
        var rootVC = presentingViewController
        while let parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        rootVC?.dismiss(animated: animated, completion: completion)
    }
}
