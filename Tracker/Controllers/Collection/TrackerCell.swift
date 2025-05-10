//
//  TrackerCell.swift
//  Tracker
//
//  Created by Алина on 07.05.2025.
//
import UIKit

final class TrackerCell: UICollectionViewCell {
    
    static let identifier = Identifier.TrackerCollection.trackerCell.text
    
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var smileView: UIView = {
        let smileView = UIView()
        smileView.backgroundColor = UIColor.ypWhite.withAlphaComponent(0.3)
        
        let size: CGFloat = 24
        [smileView].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            smileView.heightAnchor.constraint(equalToConstant: size),
            smileView.widthAnchor.constraint(equalToConstant: size)
        ])
        
        smileView.layer.cornerRadius = size / 2
        smileView.clipsToBounds = true
        
        return smileView
    }()
    
    private lazy var emojiSmile: UIImageView = {
        let emojiSmile = UIImageView()
        emojiSmile.contentMode = .scaleAspectFit
        emojiSmile.translatesAutoresizingMaskIntoConstraints = false
        return emojiSmile
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        contentView.backgroundColor = nil
        emojiSmile.image = nil
        trackerLabel.text = nil
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(trackerLabel)
        contentView.addSubview(smileView)
        smileView.addSubview(emojiSmile)
        
        let maxHeight = trackerLabel.font.lineHeight * CGFloat(trackerLabel.numberOfLines)
        
        NSLayoutConstraint.activate([
            trackerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            trackerLabel.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight),
            
            smileView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            smileView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            smileView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -131),
            
            emojiSmile.centerXAnchor.constraint(equalTo: smileView.centerXAnchor),
            emojiSmile.centerYAnchor.constraint(equalTo: smileView.centerYAnchor),
            emojiSmile.widthAnchor.constraint(equalTo: smileView.widthAnchor, multiplier: 0.6),
            emojiSmile.heightAnchor.constraint(equalTo: smileView.heightAnchor, multiplier: 0.6)
        ])
        
        trackerLabel.setContentHuggingPriority(.required, for: .vertical)
        trackerLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func configureCell(emoji: Resources.EmojiImage,text: String, color: UIColor) {
        emojiSmile.image = UIImage(named: emoji.imageName)
        trackerLabel.text = text
        contentView.backgroundColor = color
    }
}
