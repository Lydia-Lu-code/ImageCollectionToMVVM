//
//  ImageDetailViewController.swift
//  ImageCollectionToMVVM
//
//  Created by Lydia Lu on 2024/11/18.
//

import UIKit

class ImageDetailViewController: UIViewController {
    // MARK: - Properties
    private let imageItem: ImageItem
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6 // 添加背景色以便識別
        imageView.clipsToBounds = true // 添加裁剪屬性
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label // 添加文字顏色
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel // 添加文字顏色
        label.textAlignment = .left // 添加對齊方式
        return label
    }()
    
    // MARK: - Initialization
    init(imageItem: ImageItem) {
        self.imageItem = imageItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Image Detail" // 添加導航欄標題
        
        // 添加子視圖
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(noteLabel)
        
        // 設置自動佈局
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 圖片視圖約束
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            // 標題標籤約束
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 註釋標籤約束
            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            noteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        titleLabel.text = imageItem.title
        noteLabel.text = imageItem.note
        
        // 從文件目錄加載圖片
        loadImage()
    }
    
    // MARK: - Private Methods
    private func loadImage() {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imagePath = documentsPath.appendingPathComponent(imageItem.imagePath)
            
            if let imageData = try? Data(contentsOf: imagePath),
               let image = UIImage(data: imageData) {
                imageView.image = image
            } else {
                imageView.image = UIImage(systemName: "photo.fill") // 設置預設圖片
                print("Failed to load image from path: \(imagePath)")
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
}
