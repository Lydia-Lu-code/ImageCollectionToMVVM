//
//  ImageItem.swift
//  ImageCollectionToMVVM
//
//  Created by Lydia Lu on 2024/11/18.
//

import Foundation

import CoreData
import UIKit

// Core Data Model
struct ImageItem: Identifiable {
    let id: UUID
    var title: String
    var imagePath: String
    var note: String
    var dateAdded: Date
}

// MARK: - Enums
enum SortOption {
    case date
    case title
    
    var description: String {
        switch self {
        case .date: return "Date"
        case .title: return "Title"
        }
    }
}
