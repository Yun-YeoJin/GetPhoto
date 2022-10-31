//
//  SearchPhotoCollectionViewCell.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/31.
//

import UIKit

import SnapKit
import Then

class SearchPhotoCollectionViewCell: UICollectionViewCell {
    
    let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .clear
    }
    
    let photoDescriptionLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .systemMint
        $0.numberOfLines = 0
    }
    
    let photoLikeLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .systemMint
        $0.numberOfLines = 0
    }
    
    let photoLikeImageView = UIImageView().then {
        $0.image = UIImage(systemName: "heart.fill")
        $0.tintColor = .red
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [photoImageView, photoDescriptionLabel, photoLikeLabel, photoLikeImageView].forEach {
            self.addSubview($0)
        }
    }
    
    func setConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(self.snp.width).multipliedBy(0.4)
        }
        
        photoDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(photoImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        photoLikeImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(30)

        }
        photoLikeLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoLikeImageView.snp.leading).offset(30)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }

        
    }

}
