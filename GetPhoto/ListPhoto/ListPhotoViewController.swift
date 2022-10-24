//
//  ListPhotoViewController.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/24.
//

import UIKit

import Then
import SnapKit

class ListPhotoViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ListPhoto>!
    
    private var cellRegistration: UICollectionView.CellRegistration<ListPhotoCollectionViewCell, ListPhoto>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        
        configureUI()
        configureDataSource()
        
    }
    
    func configureUI() {
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func configureDataSource() {
        
        cellRegistration = UICollectionView.CellRegistration<ListPhotoCollectionViewCell, ListPhoto>(handler: { cell, indexPath, itemIdentifier in
            
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = "\(itemIdentifier.likes)"
            
            // String -> URL -> Data -> Image
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)! //String -> URL
                let data = try? Data(contentsOf: url) //URL -> Data
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!) //Data를 기반으로 Image 표현
                    cell.contentConfiguration = content //main에서 담아줘야한다!
                }
            }
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
    
    
}

extension ListPhotoViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = compositionLayout()
        layout.configuration = configuration
        return layout
    }
    
    private func compositionLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(50))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))//Label 크기에 따른 사이즈 자동 조절
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2) //2줄로 표현하겠다.
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
