//
//  BlogListCell.swift
//  SearchDaumBlog
//
//  Created by Terry on 2022/02/15.
//

import UIKit
import SnapKit
import Kingfisher

class BlogListCell: UITableViewCell {
    let thumnailImageView = UIImageView()
    let nameLabel = UILabel()
    let titleLabel = UILabel()
    let dateTimeLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumnailImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        
        dateTimeLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        [thumnailImageView,nameLabel,titleLabel,dateTimeLabel].forEach{
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(8)
            $0.trailing.lessThanOrEqualTo(thumnailImageView.snp.leading).offset(-8)
        }
        thumnailImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.top.trailing.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(80)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(thumnailImageView.snp.leading).offset(-8)
        }
        dateTimeLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(titleLabel)
            $0.bottom.equalTo(thumnailImageView)
        }
    }
    func setData(_ data: BlogListCellData){
        thumnailImageView.kf.setImage(with: data.thumnailURL, placeholder: UIImage(systemName: "photo"))
        titleLabel.text = data.title
        nameLabel.text = data.name
        
        var dateTime: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let content = data.dateTime ?? Date()
            return dateFormatter.string(from: content)
        }
        dateTimeLabel.text = dateTime
        
    }
}
