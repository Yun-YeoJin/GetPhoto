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
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "리스트 이미지를 검색해보세요."
        $0.backgroundColor = .systemBackground
    }
    
    
    private var viewModel = ListPhotoViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ListPhoto>!
    
    private var cellRegistration: UICollectionView.CellRegistration<ListPhotoCollectionViewCell, ListPhoto>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        
        searchBar.delegate = self
        
        configureUI()
        configureDataSource()
        bindListPhoto()
        
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
    
    private func bindListPhoto() {
        
        viewModel.requestListPhoto(query: "apple")
        
        viewModel.photoList.bind { [weak self] value in
            guard let self = self else { return }
            
            var snapshot = NSDiffableDataSourceSnapshot<Int, ListPhoto>()
            snapshot.appendSections([0])
            snapshot.appendItems(value)
            self.dataSource.apply(snapshot)
            
        }
    }
    
    private func configureDataSource() {
        
        cellRegistration = UICollectionView.CellRegistration<ListPhotoCollectionViewCell, ListPhoto>(handler: { cell, indexPath, itemIdentifier in
            
            
            cell.likesLabel.text = "좋아요 수 : \(itemIdentifier.likes)"
            
            // String -> URL -> Data -> Image
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)! //String -> URL
                let data = try? Data(contentsOf: url) //URL -> Data
                
                DispatchQueue.main.async {
                    cell.photoImageView.image = UIImage(data: data!) //Data를 기반으로 Image 표현
                    cell.contentConfiguration = cell.photoImageView.image as? any UIContentConfiguration //main에서 담아줘야한다!
                }
            }
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
    
    
}

extension ListPhotoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        viewModel.requestListPhoto(query: searchBar.text!)
        
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
