//
//  BackgoundReusableView.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 26/11/21.
//

import UIKit



class BackgoundReusableView: UICollectionReusableView {

    private var insetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.opacity = 0.3
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
    }
    
    func setTitle(title:String){
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
  
    }
    
}


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
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 30),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    @objc func footerBtntapped() {
        delegate.footerBtntapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
  
    }
}

