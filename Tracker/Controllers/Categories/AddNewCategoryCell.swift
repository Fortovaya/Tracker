//
//  AddNewCategoryCell.swift
//  Tracker
//
//  Created by Алина on 13.06.2025.
//

import UIKit

final class AddNewCategoryCell: UITableViewCell {

    var onTextChange: ((String) -> Void)?
    
    // MARK: - Static variables
    static let reuseIdentifier = Identifier.CategoriesTableView.addNewCategoryCell.text
    
    // MARK: - Private variables
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = TextFieldPlaceholder.categoryName.text
        textField.textColor = .ypBlack
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.clearButtonMode = .always
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - Override Methods
    override func layoutSubviews(){
        super.layoutSubviews()
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setupCell(){
        contentView.clipsToBounds = true
        contentView.addSubview(textField)
        [textField].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        contentView.backgroundColor = .ypBackgroundTF
    }
    
    //MARK: - Action
    @objc private func textChanged(_ textField: UITextField) {
        onTextChange?(textField.text ?? "")
    }
}
