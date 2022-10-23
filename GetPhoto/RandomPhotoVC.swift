//
//  RandomPhotoVC.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class RandomPhotoVC: UIViewController {
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        return view
    }()
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "랜덤 이미지를 검색해보세요."
        $0.backgroundColor = .systemBackground
    }
    
    var viewModel = RandomPhotoViewModel()
    
    private var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, RandomPhoto>!
        
    private var dataSource: UICollectionViewDiffableDataSource<Int, RandomPhoto>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        configureDataSource()
        
        setConstraints()
        
    }
    
    func setConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(0)
            make.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        
    }
    
}

extension RandomPhotoVC {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, RandomPhoto>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = "\(itemIdentifier.views)"
            
            // String -> URL -> Data -> Image
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)! //String -> URL
                let data = try? Data(contentsOf: url) //URL -> Data
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!) //Data를 기반으로 Image 표현
                    cell.contentConfiguration = content //main에서 담아줘야한다!
                }
            }
                        
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .brown
            cell.backgroundConfiguration = backgroundConfig
            
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
    
    }
}

extension RandomPhotoVC: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
