//
//  PlaceholderType.swift
//  Tracker
//
//  Created by Алина on 22.06.2025.
//

import UIKit

enum PlaceholderType {
    case emptyTrackers
    case noSearchResults
    
    var image: UIImage? {
        switch self {
            case .emptyTrackers: return UIImage(named: Resources.ImageNames.dizzy.imageName)
            case .noSearchResults: return UIImage(named: Resources.ImageNames.filter.imageName)
        }
    }
    
    var text: String {
        switch self {
            case .emptyTrackers: return Resources.Labels.dizzyLabel.text
            case .noSearchResults: return Resources.Labels.nothingFound.text
        }
    }
}
