//
//  SearchPhotoViewController.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/28.
//

import UIKit

import SnapKit
import Kingfisher

class SearchPhotoViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        return view
    }()
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "이미지를 검색해보세요."
        $0.backgroundColor = .systemBackground
    }
    
    let viewModel = SearchPhotoViewModel()
    
    private var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>!
        
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.collectionViewLayout = createLayout()
        
        searchBar.delegate = self
        
        configureUI()
        
        configureDataSource()

        viewModel.photoList.bind { photo in
            
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>() //인스턴스 처럼 생성
            snapshot.appendSections([0])//섹션 추가
            snapshot.appendItems(photo.results)//아이템 추가
            self.dataSource.apply(snapshot)
            
        }
   
    }
    
    func configureUI() {
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(0)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension SearchPhotoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        viewModel.requestSearchPhoto(query: searchBar.text!)
        
    }
    
}

extension SearchPhotoViewController {

    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = "좋아요 수 : \(itemIdentifier.likes)"
            
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)!
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    cell.contentConfiguration = content
                }
            }
                        
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
    
    }
}
