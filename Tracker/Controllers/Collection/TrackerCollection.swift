//
//  TrackerCollection.swift
//  Tracker
//
//  Created by Алина on 07.05.2025.
//
import UIKit

struct GeometricParams {
    let cellCount: Int
    let cellSpacing: CGFloat
    
    init(cellCount: Int, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.cellSpacing = cellSpacing
    }
}

final class TrackerCollection: NSObject {
    
    private let params: GeometricParams
    private unowned let collection: UICollectionView
    
    var emojis: [Resources.EmojiImage] = []
    var categories: [TrackerCategory] = []

    init(categories: [TrackerCategory],params: GeometricParams, collection: UICollectionView) {
        self.categories = categories
        self.params = params
        self.collection = collection
        
        super.init()
        
        registrationElements()
        collection.delegate = self
        collection.dataSource = self
        collection.reloadData()
    }
    
    private func registrationElements(){
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collection.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: HeaderView.headerReuseIdentifier)
        collection.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: FooterView.footerReuseIdentifier)
    }
    
    private func calculateCellWidth(for collectionView: UICollectionView) -> CGFloat {
        let totalSpacing = params.cellSpacing * CGFloat(params.cellCount - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        return availableWidth / CGFloat(params.cellCount)
    }

    func addEmoji(named rawName: String) {
        // Пытаемся создать case из rawValue
        guard let emoji = Resources.EmojiImage(rawValue: rawName) else {
            print("❌ Эмодзи «\(rawName)» не найдено в Resources.EmojiImage")
            return
        }
        // Добавляем в модель
        emojis.append(emoji)
        // Вставляем новую ячейку в конец
        let newIndex = emojis.count - 1
        collection.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerCollection: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 12, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateCellWidth(for: collectionView)
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 58)
    }
}

// MARK: UICollectionViewDataSource
extension TrackerCollection: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.section]
        let tracker  = category.trackers[indexPath.item]
        
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerCell.identifier,
                for: indexPath
            ) as? TrackerCell,
            let emoji = Resources.EmojiImage(rawValue: tracker.emojiTrackers)
        else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(
            with: emoji,
            text: tracker.nameTrackers,
            color: tracker.colorTrackers
        )
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeaderView.headerReuseIdentifier,
                    for: indexPath
                ) as! HeaderView
                header.setupTitleHeader(title: categories[indexPath.section].title)
                return header
                
            case UICollectionView.elementKindSectionFooter:
                let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: FooterView.footerReuseIdentifier,
                    for: indexPath
                ) as! FooterView
                
                footer.setupTitleFooter(forSection: indexPath.section, delegate: self, title: "")
                return footer
                
            default:
                return UICollectionReusableView()
        }
    }
}

extension TrackerCollection: FooterViewDelegate {
    func footerViewDidTapPlusButton(_ footerView: FooterView, inSection section: Int) {
        print("Плюс в футере секции \(section) нажали!")
    }
}
