//
//  TrackerCell.swift
//  Tracker
//
//  Created by Алина on 07.05.2025.
//
import UIKit

final class TrackerCell: UICollectionViewCell {
    
    private enum Constants {
        static let contentCornerRadius: CGFloat = 16
        static let emojiContainerSize: CGFloat = 24
        static let padding: CGFloat = 12
        static let labelMaxLines = 2
        static let emojiSizeMultiplier: CGFloat = 0.6
    }
    
    static let identifier = Identifier.TrackerCollection.trackerCell.text
    
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = Constants.labelMaxLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiContainerView: UIView = {
        let smileView = UIView()
        smileView.backgroundColor = UIColor.ypWhite.withAlphaComponent(0.3)
        smileView.layer.cornerRadius = Constants.emojiContainerSize / 2
        smileView.clipsToBounds = true
        return smileView
    }()
    
    private lazy var emojiImageView: UIImageView = {
        let emojiSmile = UIImageView()
        emojiSmile.contentMode = .scaleAspectFit
        emojiSmile.translatesAutoresizingMaskIntoConstraints = false
        return emojiSmile
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emojiContainerView.layer.cornerRadius = emojiContainerView.bounds.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        resetCell()
    }
    
    private func resetCell(){
        contentView.backgroundColor = nil
        emojiImageView.image = nil
        trackerLabel.text = nil
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = Constants.contentCornerRadius
        contentView.layer.masksToBounds = true
        
        contentView.addSubviews([trackerLabel,emojiContainerView])
        emojiContainerView.addSubview(emojiImageView)
        
        let maxHeight = trackerLabel.font.lineHeight * CGFloat(trackerLabel.numberOfLines)
        
        NSLayoutConstraint.activate([
            trackerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            trackerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            trackerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
            trackerLabel.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight),
            
            emojiContainerView.heightAnchor.constraint(equalToConstant: Constants.emojiContainerSize),
            emojiContainerView.widthAnchor.constraint(equalToConstant: Constants.emojiContainerSize),
            emojiContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            emojiContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            emojiContainerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -131),
            
            emojiImageView.centerXAnchor.constraint(equalTo: emojiContainerView.centerXAnchor),
            emojiImageView.centerYAnchor.constraint(equalTo: emojiContainerView.centerYAnchor),
            emojiImageView.widthAnchor.constraint(equalTo: emojiContainerView.widthAnchor,multiplier: Constants.emojiSizeMultiplier),
            emojiImageView.heightAnchor.constraint(equalTo: emojiContainerView.heightAnchor,multiplier: Constants.emojiSizeMultiplier)
        ])
        
        trackerLabel.setContentHuggingPriority(.required, for: .vertical)
        trackerLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func configureCell(with emoji: Resources.EmojiImage,text: String, color: UIColor) {
        emojiImageView.image = UIImage(named: emoji.imageName)
        trackerLabel.text = text
        contentView.backgroundColor = color
    }
}
