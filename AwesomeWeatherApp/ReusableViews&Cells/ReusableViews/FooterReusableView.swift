//
//  FooterReusableView.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 28/11/21.
//

import UIKit

class FooterReusableView: UICollectionReusableView {
    
    
    var button = UIButton(type: .roundedRect)
    var delegate: HomeViewControllerDelegate!
    
    var modelToBeTransfered: [Forecastday]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        button.setTitle("3-days Forecast", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.
//        button.center = self.center
        button.setTitleColor(UIColor(named: "buttonTitleColor"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(footerBtntapped), for: .touchUpInside)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 40),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
    }
    
    @objc func footerBtntapped() {
        delegate.footerBtntapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
  
    }
}
