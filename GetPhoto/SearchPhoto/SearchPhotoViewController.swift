//
//  SearchPhotoViewController.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/28.
//

import UIKit

import SnapKit
import Kingfisher
import RxCocoa
import RxSwift

class SearchPhotoViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.delegate = self
        return view
    }()
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "이미지를 검색해보세요."
        $0.backgroundColor = .systemBackground
    }
    
    let viewModel = SearchPhotoViewModel()
    
    private var cellRegisteration: UICollectionView.CellRegistration<SearchPhotoCollectionViewCell, SearchResult>!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>?
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Unsplash Photo 검색기"
        navigationController?.navigationBar.tintColor = .systemMint
        navigationController?.navigationBar.backgroundColor = .systemBackground
       
        searchBar.delegate = self
        
        collectionView.collectionViewLayout = createLayout()

        configureUI()
        configureDataSource()
        
        viewModel.photoList
            .withUnretained(self)
            .bind(onNext: { vc, photo in
                guard let dataSource = vc.dataSource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>() //인스턴스 처럼 생성
                snapshot.appendSections([0])//섹션 추가
                snapshot.appendItems(photo.results)//아이템 추가
                dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        
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
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let item = NSCollectionLayoutItem(layoutSize: size)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        cellRegisteration = UICollectionView.CellRegistration<SearchPhotoCollectionViewCell, SearchResult>(handler: { cell, indexPath, itemIdentifier in
            
            let url = URL(string: itemIdentifier.urls.thumb)
            cell.photoImageView.kf.setImage(with: url!)
            cell.photoDescriptionLabel.text = itemIdentifier.resultDescription
            cell.photoLikeLabel.text = "\(itemIdentifier.likes)"
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
}

extension SearchPhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? SearchPhotoCollectionViewCell else { return }
        viewModel.addFolder(item: item, text: self.searchBar.text!)
        DocumentManager.shared.saveImageToDocument(fileName: "\(item.id)", image: cell.photoImageView.image!)
        
    }
    
}
