//
//  BackgoundReusableView.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 26/11/21.
//
 
import UIKit



class BackgoundReusableView: UICollectionReusableView {
    
    var insetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.opacity = 0.15
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
   

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(insetView)

        NSLayoutConstraint.activate([
            insetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: insetView.trailingAnchor, constant: 0),
            insetView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            insetView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
  
    }
}







