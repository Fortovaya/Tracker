//
//  TrackerCell.swift
//  Tracker
//
//  Created by Алина on 07.05.2025.
//
import UIKit

final class TrackerCell: UICollectionViewCell {
    // MARK: - Enum Constants
    private enum Constants {
        static let contentCornerRadius: CGFloat = 16
        static let emojiContainerSize: CGFloat = 24
        static let padding: CGFloat = 12
        static let labelMaxLines = 2
        static let emojiSizeMultiplier: CGFloat = 0.9
        static let plusButtonSize: CGFloat = 34
        static let bottomSpacing: CGFloat = 8
    }
    //MARK: - Delegate
    weak var delegate: TrackerCellDelegate?
    
    static let identifier = Identifier.TrackerCollection.trackerCell.text
    // MARK: - Private variables
    private var trackerId: UUID?
    
    private lazy var containerCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = Constants.contentCornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        return view
    }()
    
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhite
        label.numberOfLines = Constants.labelMaxLines
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
        smileView.translatesAutoresizingMaskIntoConstraints = false
        return smileView
    }()
    
    private lazy var emojiImageView: UIImageView = {
        let emojiSmile = UIImageView()
        emojiSmile.contentMode = .scaleAspectFit
        emojiSmile.translatesAutoresizingMaskIntoConstraints = false
        return emojiSmile
    }()
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Resources.ButtonIcons.plus.imageName), for: .normal)
        button.setImage(UIImage(named: Resources.ButtonIcons.checkmark.imageName), for: .selected)
        button.tintColor = .ypWhite
        button.backgroundColor = containerCellView.backgroundColor
        
        [button].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: Constants.plusButtonSize),
            button.widthAnchor.constraint(equalToConstant: Constants.plusButtonSize)
        ])
        
        button.layer.cornerRadius = Constants.plusButtonSize / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var emojiFooterView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 58)
        ])
        
        return view
    }()
    
    private lazy var collectionCellStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [containerCellView, emojiFooterView])
        stack.axis = .vertical
        stack.spacing = .zero
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Override Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        plusButton.isSelected = false
        plusButton.backgroundColor = containerCellView.backgroundColor
        updatePlusButtonAlpha()
        resetCell()
    }
    
    // MARK: - Private Methods
    private func resetCell(){
        contentView.backgroundColor = nil
        emojiImageView.image = nil
        trackerLabel.text = nil
        daysLabel.text = nil
        plusButton.isSelected = false
        plusButton.backgroundColor = nil
        updatePlusButtonAlpha()
        trackerId = nil
    }
    
    private func setupCell() {
        let maxLabelHeight = daysLabel.font.lineHeight * CGFloat(daysLabel.numberOfLines)
        
        contentView.addSubviews([collectionCellStackView])
        containerCellView.addSubviews([emojiContainerView,trackerLabel])
        emojiContainerView.addSubviews([emojiImageView])
        emojiFooterView.addSubviews([plusButton,daysLabel])
        
        NSLayoutConstraint.activate([
            collectionCellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionCellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionCellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionCellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiContainerView.heightAnchor.constraint(equalToConstant: Constants.emojiContainerSize),
            emojiContainerView.widthAnchor.constraint(equalToConstant: Constants.emojiContainerSize),
            emojiContainerView.topAnchor.constraint(equalTo: containerCellView.topAnchor, constant: Constants.padding),
            emojiContainerView.leadingAnchor.constraint(equalTo: containerCellView.leadingAnchor, constant: Constants.padding),
            emojiContainerView.trailingAnchor.constraint(lessThanOrEqualTo: containerCellView.trailingAnchor,constant: -131),
            
            emojiImageView.centerXAnchor.constraint(equalTo: emojiContainerView.centerXAnchor),
            emojiImageView.centerYAnchor.constraint(equalTo: emojiContainerView.centerYAnchor),
            emojiImageView.widthAnchor.constraint(equalToConstant: 24),
            emojiImageView.heightAnchor.constraint(equalToConstant: 24),
            
            trackerLabel.topAnchor.constraint(equalTo: emojiContainerView.bottomAnchor, constant: Constants.padding),
            trackerLabel.leadingAnchor.constraint(equalTo: containerCellView.leadingAnchor, constant: Constants.padding),
            trackerLabel.trailingAnchor.constraint(equalTo: containerCellView.trailingAnchor, constant: -Constants.padding),
            trackerLabel.bottomAnchor.constraint(equalTo: containerCellView.bottomAnchor, constant: -Constants.padding),
            trackerLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 34),
            
            plusButton.topAnchor.constraint(equalTo: emojiFooterView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: emojiFooterView.trailingAnchor, constant: -12),
            plusButton.bottomAnchor.constraint(equalTo: emojiFooterView.bottomAnchor, constant: -16),
            
            daysLabel.heightAnchor.constraint(equalToConstant: maxLabelHeight),
            daysLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            daysLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            daysLabel.leadingAnchor.constraint(equalTo: emojiFooterView.leadingAnchor, constant: 12)
        ])
        
        trackerLabel.setContentHuggingPriority(.required, for: .vertical)
        trackerLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func updatePlusButtonAlpha() {
        guard let baseColor = containerCellView.backgroundColor else { return }
        let alpha: CGFloat = plusButton.isSelected ? 0.5 : 1.0
        plusButton.backgroundColor = baseColor.withAlphaComponent(alpha)
    }
    
    //MARK: - Public Methods
    func configureCell(with emoji: Resources.EmojiImage,
                       text: String,
                       color: UIColor,
                       idTrackers: UUID,
                       for date: Date) {
        emojiImageView.image = UIImage(named: emoji.imageName)
        trackerLabel.text = text
        containerCellView.backgroundColor = color
        plusButton.backgroundColor = color
        trackerId = idTrackers
        
        let total = delegate?.completedDaysCount(for: idTrackers) ?? 0
        daysLabel.text = "\(total) \(delegate?.dayString(for: total) ?? "дней")"
        let isDoneToday = delegate?.isTrackerCompleted(for: idTrackers, on: date) ?? false
        plusButton.isSelected = isDoneToday
        updatePlusButtonAlpha()
    }
    
    
    
    //MARK: - Action
    @objc private func didTapPlusButton(){
        plusButton.isSelected.toggle()
        updatePlusButtonAlpha()
        guard let trackerId = trackerId else { return }
        delegate?.trackerCellDidTapPlus(self, id: trackerId)
    }
}
