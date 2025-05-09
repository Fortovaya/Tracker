//
//  FooterView.swift
//  Tracker
//
//  Created by Алина on 09.05.2025.
//
import UIKit

final class FooterView: UICollectionReusableView {
    
    weak var delegate: FooterViewDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Resources.ButtonIcons.plus.imageName), for: .normal)
        button.tintColor = .ypWhite
        
        let size: CGFloat = 34
        
        [button].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: size),
            button.widthAnchor.constraint(equalToConstant: size)
        ])
        
        button.layer.borderColor = UIColor.ypBlackBorder.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = size / 2
        button.clipsToBounds = true
        button.addTarget(nil, action: #selector(didTapPlusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,plusButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurationFooterView()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    private func configurationFooterView(){
        addSubview(footerStackView)
        
        [footerStackView].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            footerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            footerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            footerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            footerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setupTitleFooter(title: String){
        titleLabel.text = title
    }
    
    @objc private func didTapPlusButton(){
        //TO DO:
    }
}
