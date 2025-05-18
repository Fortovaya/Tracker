//
//  BaseButton.swift
//  Tracker
//
//  Created by Алина on 02.05.2025.
//
import UIKit

final class BaseButton: HighlightableButton {
    //MARK: - Init
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
        setupLayout(height)
        setupAppearance(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            borderColor: borderColor,
            borderWidth: borderWidth
        )
        setupTitle(title: title, titleColor: titleColor)
        setupAction(target: target, action: action)
    }
    
    // MARK: - Private Methods
    private func setupLayout(_ height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func setupAppearance(backgroundColor: UIColor,cornerRadius: CGFloat, borderColor: UIColor?,
                                 borderWidth: CGFloat) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
    
    private func setupTitle(title: Resources.TitleButtons, titleColor: UIColor) {
        self.setTitle(title.text, for: .normal)
        self.accessibilityLabel = title.text
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment   = .center
        self.titleLabel?.textAlignment  = .center
    }
    
    private func setupAction(target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // MARK: - required
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}
