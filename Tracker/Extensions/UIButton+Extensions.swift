//
//  UIButton+Extensions.swift
//  Tracker
//
//  Created by Алина on 29.04.2025.
//
import UIKit

extension UIButton {
    static func makeButton(
        title: String,
        backgroundColor: UIColor = .ypBlack,
        titleColor: UIColor    = .ypWhite,
        cornerRadius: CGFloat  = 16,
        height: CGFloat        = 60,
        width: CGFloat        = 335,
        target: Any?,
        action: Selector
    ) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment   = .center
        button.titleLabel?.textAlignment  = .center
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return button
    }
}
