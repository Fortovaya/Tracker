//
//  DropdownButton.swift
//  Tracker
//
//  Created by Алина on 02.05.2025.
//
import UIKit

final class DropdownButton: UIButton {
    
    private lazy var label = UILabel()
    private lazy var chevron = UIImageView()
    private lazy var contentStack = UIStackView()
    
    init(
        title: Resources.TitleButtons,
        font: UIFont = .systemFont(ofSize: 17, weight: .regular),
        titleColor: UIColor = .ypBlack,
        backgroundColor: UIColor = .ypBackgroundTF,
        image: String = "chevron",
        height: CGFloat = 75,
        horizontalInset: CGFloat = 16,
        spacing: CGFloat = 8,
        target: Any? = nil,
        action: Selector? = nil
    ) {
        super.init(frame: .zero)
        setupAppearance( backgroundColor: backgroundColor,height: height)
        setupContentStack(title: title.rawValue,font: font,titleColor: titleColor,imageName: image,spacing: spacing)
        setupConstraints(horizontalInset: horizontalInset)
        setupTarget(target: target, action: action)
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    // MARK: - Private Methods
    private func setupAppearance(backgroundColor: UIColor, height: CGFloat) {
        self.backgroundColor = backgroundColor
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func setupContentStack(
        title: String,
        font: UIFont,
        titleColor: UIColor,
        imageName: String,
        spacing: CGFloat
    ) {
        label.text = title
        label.font = font
        label.textColor = titleColor
        
        chevron.image = UIImage(named: imageName) ?? UIImage(systemName: imageName)
        chevron.tintColor = titleColor
        chevron.contentMode = .scaleAspectFit
        
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = spacing
        contentStack.isUserInteractionEnabled = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addArrangedSubview(label)
        contentStack.addArrangedSubview(chevron)
        
        addSubview(contentStack)
        
        self.accessibilityLabel = title
        self.accessibilityTraits = .button
    }
    
    private func setupConstraints(horizontalInset: CGFloat) {
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalInset),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalInset),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chevron.widthAnchor.constraint(equalToConstant: 7),
            chevron.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func setupTarget(target: Any?, action: Selector?) {
        guard let target = target, let action = action else { return }
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}

