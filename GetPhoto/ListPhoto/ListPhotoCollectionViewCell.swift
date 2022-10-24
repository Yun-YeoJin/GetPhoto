//
//  ListPhotoCollectionViewCell.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/24.
//

import UIKit

import Then
import SnapKit

class ListPhotoCollectionViewCell: UICollectionViewCell {
    
    let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    let likesLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(likesLabel)
        
        photoImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(8)
            make.width.height.equalTo(50)
        }
        
        likesLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.leading.equalTo(photoImageView.snp.trailing).offset(8)
        }
        
    }
}

