//
//  TrackerCollection.swift
//  Tracker
//
//  Created by Алина on 07.05.2025.
//
import UIKit

final class TrackerCollection: NSObject {
    
   
    
}


extension TrackerCollection: UICollectionViewDelegateFlowLayout {
    
}

extension TrackerCollection: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
