//
//  ImageCollectionViewController.swift
//  ImageCollectionToMVVM
//
//  Created by Lydia Lu on 2024/11/18.
//

import UIKit

class ImageCollectionViewController: UIViewController {
    private var collectionView: UICollectionView!
    private lazy var viewModel = ImageCollectionViewModel(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 30) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Image Collection"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                          target: self,
                                                          action: #selector(addButtonTapped))
        
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(sortButtonTapped))
        navigationItem.leftBarButtonItem = sortButton
    }
    
    @objc private func addButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func sortButtonTapped() {
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: SortOption.date.description, style: .default) { [weak self] _ in
            self?.viewModel.sort(by: .date)
        })
        
        alert.addAction(UIAlertAction(title: SortOption.title.description, style: .default) { [weak self] _ in
            self?.viewModel.sort(by: .title)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - Collection View Delegates
extension ImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getImagesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        
        let imageItem = viewModel.getImage(at: indexPath.item)
        cell.configure(with: imageItem)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageItem = viewModel.getImage(at: indexPath.item)
        // Present detail view controller
        let detailVC = ImageDetailViewController(imageItem: imageItem)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Image Picker Delegate
extension ImageCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(title: "Add Image",
                                        message: "Please enter image details",
                                        preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.placeholder = "Title"
            }
            
            alert.addTextField { textField in
                textField.placeholder = "Note"
            }
            
            alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                let title = alert.textFields?[0].text ?? "Untitled"
                let note = alert.textFields?[1].text ?? ""
                self?.viewModel.addImage(image, title: title, note: note)
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self?.present(alert, animated: true)
        }
    }
}

// MARK: - View Protocol Implementation
extension ImageCollectionViewController: ImageCollectionViewProtocol {
    func reloadData() {
        collectionView.reloadData()
    }
}
