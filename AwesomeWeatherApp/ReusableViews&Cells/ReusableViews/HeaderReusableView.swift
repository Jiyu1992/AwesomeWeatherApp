//
//  HeaderReusableView.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 28/11/21.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
//        titleLabel.center = self.center
    
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
    }
    
    func setTitle(title:String){
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
  
    }
    
}
