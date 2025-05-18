//
//  MakeSelectCategoryButton.swift
//  Tracker
//
//  Created by Алина on 11.05.2025.
//
import UIKit

final class MakeSelectCategoryButton: HighlightableButton {
    
    private let horizontalPadding: CGFloat = 16
    private let imageRightPadding: CGFloat = 16
    private let imageWidth: CGFloat = 14
    private let spacing: CGFloat = 8
    
    private var shouldHideImage: Bool = true
    
    var isImageHidden: Bool {
        get { shouldHideImage }
        set {
            shouldHideImage = newValue
            setNeedsLayout()
        }
    }
    
    init(
        title: String,
        backgroundColor: UIColor = .ypBackgroundTF,
        titleColor: UIColor = .ypBlack,
        font: UIFont = .systemFont(ofSize: 17, weight: .regular),
        image: UIImage? = UIImage(named: Resources.ButtonIcons.checkmark.imageName),
        cornerRadius: CGFloat = 16,
        height: CGFloat = 75,
        tintColor: UIColor = .red,
        target: Any?,
        action: Selector
    ) {
        super.init(frame: .zero)
        
        configureButton(title: title,
                        backgroundColor: backgroundColor,
                        titleColor: titleColor,
                        font: font,
                        image: image,
                        cornerRadius: cornerRadius,
                        height: height,
                        target: target,
                        action: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(
        title: String,
        backgroundColor: UIColor,
        titleColor: UIColor,
        font: UIFont,
        image: UIImage?,
        cornerRadius: CGFloat,
        height: CGFloat,
        target: Any?,
        action: Selector
    ) {
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = font
        titleLabel?.textAlignment = .left
        titleLabel?.lineBreakMode = .byTruncatingTail
        
        setImage(image, for: .normal)
        tintColor = tintColor
        imageView?.contentMode = .scaleAspectFit
        
        contentHorizontalAlignment = .left
        contentVerticalAlignment = .center
        contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: horizontalPadding,
            bottom: 0,
            right: imageRightPadding + imageWidth
        )
        
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        if height > 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.isHidden = shouldHideImage
        
        guard let imageView = imageView, !imageView.isHidden else { return }
        
        let availableWidth = bounds.width - horizontalPadding - imageRightPadding - imageWidth - spacing
        
        imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: availableWidth,
            bottom: 0,
            right: -availableWidth
        )
        
        titleLabel?.frame.size.width = min(
            titleLabel?.frame.width ?? 0,
            availableWidth
        )
    }
}
