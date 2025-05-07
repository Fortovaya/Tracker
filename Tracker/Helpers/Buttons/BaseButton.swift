//
//  BaseButton.swift
//  Tracker
//
//  Created by Алина on 02.05.2025.
//
import UIKit

final class BaseButton: HighlightableButton {
        
    init(
        title: Resources.TitleButtons,
        backgroundColor: UIColor = .ypBlack,
        titleColor: UIColor = .ypWhite,
        cornerRadius: CGFloat = 16,
        height: CGFloat = 60,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0,
        target: Any?,
        action: Selector
    ) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
        }
        
        self.setTitle(title.text, for: .normal)
        self.accessibilityLabel = title.text
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment   = .center
        self.titleLabel?.textAlignment  = .center
        
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}
