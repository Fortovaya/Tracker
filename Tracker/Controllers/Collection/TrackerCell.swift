//
//  TrackerCell.swift
//  Tracker
//
//  Created by Алина on 07.05.2025.
//
import UIKit

final class TrackerCell: UICollectionViewCell {
    
    static let identifier = Identifier.TrackerCollection.trackerCell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        contentView.backgroundColor = nil
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
}
