//
//  HeaderView.swift
//  Tracker
//
//  Created by Алина on 09.05.2025.
//
import UIKit

final class HeaderView: UICollectionReusableView {
    
    static let headerReuseIdentifier = Identifier.TrackerCollection.headerView.text
    
    // MARK: Private variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurationHeaderView()
    }
    
    //MARK: - required
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: -Private Methods
    private func configurationHeaderView(){
        addSubview(titleLabel)
        
        [titleLabel].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundColor = .clear
    }
    
    func setupTitleHeader(title: String){
        titleLabel.text = title
    }
}
