//
//  ImageCollectionViewModel.swift
//  ImageCollectionToMVVM
//
//  Created by Lydia Lu on 2024/11/18.
//

import Foundation
import CoreData
import UIKit

class ImageCollectionViewModel: SortableCollection {
    private var images: [ImageItem] = []
    private weak var view: ImageCollectionViewProtocol?
    
    init(view: ImageCollectionViewProtocol) {
        self.view = view
        loadImages()
    }
    
    func loadImages() {
        // Load images from Core Data
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        
        do {
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            images = results.map { entity in
                ImageItem(id: entity.id ?? UUID(),
                         title: entity.title ?? "",
                         imagePath: entity.imagePath ?? "",
                         note: entity.note ?? "",
                         dateAdded: entity.dateAdded ?? Date())
            }
            view?.reloadData()
        } catch {
            print("Error fetching images: \(error)")
        }
    }
    
    func addImage(_ image: UIImage, title: String, note: String) {
        // Save image to documents directory
        let imagePath = saveImageToDocuments(image)
        
        // Create Core Data entity
        let entity = ImageEntity(context: CoreDataManager.shared.context)
        entity.id = UUID()
        entity.title = title
        entity.imagePath = imagePath
        entity.note = note
        entity.dateAdded = Date()
        
        CoreDataManager.shared.saveContext()
        loadImages()
    }
    
    func deleteImage(at index: Int) {
        let image = images[index]
        
        // Delete from Core Data
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", image.id as CVarArg)
        
        do {
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            if let entityToDelete = results.first {
                CoreDataManager.shared.context.delete(entityToDelete)
                CoreDataManager.shared.saveContext()
            }
        } catch {
            print("Error deleting image: \(error)")
        }
        
        loadImages()
    }
    
    func sort(by option: SortOption) {
        switch option {
        case .date:
            images.sort { $0.dateAdded > $1.dateAdded }
        case .title:
            images.sort { $0.title < $1.title }
        }
        view?.reloadData()
    }
    
    private func saveImageToDocuments(_ image: UIImage) -> String {
        let fileName = UUID().uuidString + ".jpg"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagePath = documentsPath.appendingPathComponent(fileName)
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            try? imageData.write(to: imagePath)
        }
        
        return fileName
    }
    
    func getImage(at index: Int) -> ImageItem {
        return images[index]
    }
    
    func getImagesCount() -> Int {
        return images.count
    }
}
