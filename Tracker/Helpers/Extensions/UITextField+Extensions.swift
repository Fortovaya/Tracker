//
//  UITextField+Extensions.swift
//  Tracker
//
//  Created by Алина on 30.04.2025.
//
import UIKit

extension UITextField {
    
    static func makeClearableTextField(
        placeholder: TextFieldPlaceholder,
        backgroundColor: UIColor = .ypBackgroundTF,
        placeholderColor: UIColor = .ypGray,
        height: CGFloat = 0,
        cornerRadius: CGFloat = 16,
        clearButtonImage: UIImage? = UIImage(named: "xmark.circle"),
        target: Any? = nil,
        action: Selector? = nil
    ) -> UITextField {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder.text,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        textField.backgroundColor = backgroundColor
        textField.layer.cornerRadius = cornerRadius
        textField.textColor = .ypBlack
        textField.layer.masksToBounds = true
        
        if height > 0 {
            textField.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        let clearButton = UIButton(type: .system)
        clearButton.setImage(clearButtonImage, for: .normal)
        clearButton.tintColor = .ypGray
        clearButton.sizeToFit()
        clearButton.addTarget(textField,action: #selector(clearButtonTapped),for: .touchUpInside)
        
        let containerWidth = clearButton.bounds.width + 12
        let container = UIView(frame: CGRect(x: 0, y: 0,
                                             width: containerWidth,
                                             height: clearButton.bounds.height))
        
        clearButton.frame.origin = .zero
        container.addSubview(clearButton)
        
        textField.rightView = container
        textField.rightViewMode = .whileEditing
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        
        if let target = target, let action = action {
            textField.addTarget(target, action: action, for: .editingChanged)
        }
        
        return textField
    }
    
    @objc private func clearButtonTapped() {
        self.text = nil
        self.sendActions(for: .editingChanged)
        self.resignFirstResponder()
    }
}
